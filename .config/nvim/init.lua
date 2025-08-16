local cache_path = vim.fn.stdpath("cache") .. "/dpp/repos/github.com"
local dppSrc = cache_path .. "/Shougo/dpp.vim"
local denopsSrc = cache_path .. "/vim-denops/denops.vim"

-- Add path to runtimepath
vim.opt.runtimepath:prepend(dppSrc)

-- check repository exists.
local function ensure_repo_exists(repo_url, dest_path)
	if not vim.loop.fs_stat(dest_path) then
		vim.fn.system({ "git", "clone", "https://github.com/" .. repo_url, dest_path })
	end
end

ensure_repo_exists("vim-denops/denops.vim.git", denopsSrc)
ensure_repo_exists("Shougo/dpp.vim.git", dppSrc)

-- dpp.vimがロードされるまで待つ
local dpp = nil
local ok, dpp_module = pcall(require, "dpp")
if ok then
	dpp = dpp_module
end

local dppBase = vim.fn.stdpath("cache") .. "/dpp"
local dppConfig = vim.fn.stdpath("config") .. "/config.ts"

-- option.
local extension_urls = {
	"Shougo/dpp-ext-installer.git",
	"Shougo/dpp-ext-toml.git",
	"Shougo/dpp-protocol-git.git",
	"Shougo/dpp-ext-lazy.git",
	"Shougo/dpp-ext-local.git",
}

-- Ensure each extension is installed and add to runtimepath
for _, url in ipairs(extension_urls) do
	local ext_path = cache_path .. "/" .. string.gsub(url, ".git", "")
	ensure_repo_exists(url, ext_path)
	vim.opt.runtimepath:append(ext_path)
end

-- vim.g.denops_server_addr = "127.0.0.1:41979"
-- vim.g["denops#debug"] = 1

-- dpp.vimの初期化
if dpp and dpp.load_state then
	if dpp.load_state(dppBase) then
		vim.opt.runtimepath:prepend(denopsSrc)
		vim.api.nvim_create_augroup("ddp", {})

		vim.api.nvim_create_autocmd("User", {
			pattern = "DenopsReady",
			callback = function()
				if dpp and dpp.make_state then
					dpp.make_state(dppBase, dppConfig)
				end
			end,
		})
	end
else
	-- dppモジュールが使えない場合は、vim scriptの関数を使う
	vim.opt.runtimepath:prepend(denopsSrc)
end

vim.api.nvim_create_autocmd("User", {
	pattern = "Dpp:makeStatePost",
	callback = function()
		vim.notify("dpp make_state() is done")
	end,
})

-- VimScript APIを使った初期化
if vim.fn.exists('*dpp#min#load_state') == 1 then
	if vim.fn["dpp#min#load_state"](dppBase) == 1 then
		vim.api.nvim_create_autocmd("User", {
			pattern = "DenopsReady",
			callback = function()
				vim.notify("DenopsReady: Initializing dpp.vim...")
				if vim.fn.exists('*dpp#make_state') == 1 then
					vim.fn["dpp#make_state"](dppBase, dppConfig)
				elseif dpp and dpp.make_state then
					dpp.make_state(dppBase, dppConfig)
				end
			end,
		})
	end
end

vim.cmd("filetype indent plugin on")
vim.cmd("syntax on")

-- 基本設定の読み込み（プラグインに依存しない設定）
-- バックアップディレクトリから復元
local backup_dir = vim.fn.stdpath("config") .. "/backup_lazy_to_dpp"
if vim.fn.isdirectory(backup_dir) == 1 then
	-- 基本設定モジュールを読み込む
	package.path = backup_dir .. "/?.lua;" .. package.path
	
	-- エラーを無視して各モジュールを読み込む
	local modules = {"base", "options", "keymaps", "autocmds"}
	for _, module in ipairs(modules) do
		local ok, _ = pcall(require, module)
		if not ok then
			-- バックアップから直接読み込めない場合は、lua_bkから試す
			local lua_bk_dir = vim.fn.stdpath("config") .. "/lua_bk"
			if vim.fn.isdirectory(lua_bk_dir) == 1 then
				package.path = lua_bk_dir .. "/?.lua;" .. package.path
				pcall(require, module)
			end
		end
	end
end

-- install
vim.api.nvim_create_user_command("DppInstall", "call dpp#async_ext_action('installer', 'install')", {})

-- update
vim.api.nvim_create_user_command("DppUpdate", function(opts)
	local args = opts.fargs
	vim.fn["dpp#async_ext_action"]("installer", "update", { names = args })
end, { nargs = "*" })

-- make state
vim.api.nvim_create_user_command("DppMakeState", function()
	vim.fn["dpp#make_state"](vim.fn.stdpath("cache") .. "/dpp", vim.fn.stdpath("config") .. "/config.ts")
end, {})

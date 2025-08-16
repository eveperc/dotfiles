-- Simplified dpp.vim initialization for testing
local cache_path = vim.fn.stdpath("cache") .. "/dpp"
local dpp_repo = cache_path .. "/repos/github.com/Shougo/dpp.vim"
local denops_repo = cache_path .. "/repos/github.com/vim-denops/denops.vim"

-- Ensure dpp.vim and denops.vim are installed
local function ensure_installed(repo_url, install_path)
	if not vim.loop.fs_stat(install_path) then
		print("Installing " .. repo_url .. "...")
		vim.fn.system({ "git", "clone", "--depth=1", repo_url, install_path })
	end
end

ensure_installed("https://github.com/vim-denops/denops.vim", denops_repo)
ensure_installed("https://github.com/Shougo/dpp.vim", dpp_repo)

-- Add to runtimepath
vim.opt.runtimepath:prepend(denops_repo)
vim.opt.runtimepath:prepend(dpp_repo)

-- Install extensions
local extensions = {
	"dpp-ext-installer",
	"dpp-ext-toml",
	"dpp-protocol-git",
	"dpp-ext-lazy",
	"dpp-ext-local",
}

for _, ext in ipairs(extensions) do
	local ext_path = cache_path .. "/repos/github.com/Shougo/" .. ext
	ensure_installed("https://github.com/Shougo/" .. ext, ext_path)
	vim.opt.runtimepath:append(ext_path)
end

-- Basic settings
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

-- Initialize dpp.vim after VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- Check if dpp functions are available
		if vim.fn.exists('*dpp#begin') == 1 then
			local config_path = vim.fn.stdpath("config") .. "/config.ts"
			
			-- Simple initialization
			vim.fn["dpp#begin"](cache_path, {})
			
			-- Load plugins from TOML
			local toml_path = vim.fn.stdpath("config") .. "/dpp/plugins.toml"
			if vim.fn.filereadable(toml_path) == 1 and vim.fn.exists('*dpp#load_toml') == 1 then
				vim.fn["dpp#load_toml"](toml_path, {lazy = 0})
			end
			
			local lazy_toml = vim.fn.stdpath("config") .. "/dpp/lazy.toml"
			if vim.fn.filereadable(lazy_toml) == 1 and vim.fn.exists('*dpp#load_toml') == 1 then
				vim.fn["dpp#load_toml"](lazy_toml, {lazy = 1})
			end
			
			vim.fn["dpp#end"]()
			
			print("dpp.vim initialized. Use :DppInstall to install plugins.")
		else
			print("dpp.vim functions not found. Waiting for denops...")
			
			-- Try again when denops is ready
			vim.api.nvim_create_autocmd("User", {
				pattern = "DenopsReady",
				once = true,
				callback = function()
					print("Denops ready, initializing dpp.vim...")
					vim.cmd("source " .. vim.fn.stdpath("config") .. "/init_simple.lua")
				end,
			})
		end
	end,
})

-- Commands
vim.api.nvim_create_user_command("DppInstall", function()
	if vim.fn.exists('*dpp#install') == 1 then
		vim.fn["dpp#install"]()
	elseif vim.fn.exists('*dpp#async_ext_action') == 1 then
		vim.fn["dpp#async_ext_action"]('installer', 'install')
	else
		print("dpp.vim is not initialized yet. Please wait...")
	end
end, {})

vim.api.nvim_create_user_command("DppUpdate", function()
	if vim.fn.exists('*dpp#update') == 1 then
		vim.fn["dpp#update"]()
	elseif vim.fn.exists('*dpp#async_ext_action') == 1 then
		vim.fn["dpp#async_ext_action"]('installer', 'update')
	else
		print("dpp.vim is not initialized yet. Please wait...")
	end
end, {})

-- Load basic configurations
local config_modules = {"base", "options", "keymaps", "autocmds"}
for _, module in ipairs(config_modules) do
	local backup_path = vim.fn.stdpath("config") .. "/lua_bk/" .. module .. ".lua"
	if vim.fn.filereadable(backup_path) == 1 then
		vim.cmd("source " .. backup_path)
	end
end

print("Starting Neovim with dpp.vim...")
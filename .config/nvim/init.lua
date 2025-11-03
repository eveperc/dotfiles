-- =====================================================================
-- dpp.vim based Neovim configuration
-- =====================================================================

-- Cache paths
local cache_path = vim.fn.stdpath("cache") .. "/dpp"
local repo_path = cache_path .. "/repos/github.com"
local dpp_src = repo_path .. "/Shougo/dpp.vim"
local denops_src = repo_path .. "/vim-denops/denops.vim"
local config_path = vim.fn.stdpath("config")

-- Helper function to ensure repository exists
local function ensure_repo(repo_url, dest_path)
  if not vim.loop.fs_stat(dest_path) then
    print("Cloning " .. repo_url .. "...")
    vim.fn.system({ "git", "clone", "https://github.com/" .. repo_url, dest_path })
  end
end

-- Essential repositories (order matters!)
local repos = {
  { url = "vim-denops/denops.vim.git", path = denops_src },
  { url = "Shougo/dpp.vim.git", path = dpp_src },
  { url = "Shougo/dpp-ext-installer.git", path = repo_path .. "/Shougo/dpp-ext-installer" },
  { url = "Shougo/dpp-ext-toml.git", path = repo_path .. "/Shougo/dpp-ext-toml" },
  { url = "Shougo/dpp-protocol-git.git", path = repo_path .. "/Shougo/dpp-protocol-git" },
  { url = "Shougo/dpp-ext-lazy.git", path = repo_path .. "/Shougo/dpp-ext-lazy" },
  { url = "Shougo/dpp-ext-local.git", path = repo_path .. "/Shougo/dpp-ext-local" },
}

-- Clone essential repositories and add to runtimepath
for _, repo in ipairs(repos) do
  ensure_repo(repo.url, repo.path)
end

-- Add dpp to runtimepath FIRST (must be before checking functions)
vim.opt.runtimepath:prepend(dpp_src)
vim.opt.runtimepath:prepend(denops_src)

-- Add extensions to runtimepath
for i = 3, #repos do
  vim.opt.runtimepath:append(repos[i].path)
end

-- Fix Lua module path for dpp plugins immediately
local function add_dpp_lua_paths()
  local dpp_repos = cache_path .. "/repos/github.com"
  
  -- Add specific known paths first
  local lspconfig_path = dpp_repos .. "/neovim/nvim-lspconfig/lua"
  if vim.fn.isdirectory(lspconfig_path) == 1 then
    package.path = package.path .. ";" .. lspconfig_path .. "/?.lua;" .. lspconfig_path .. "/?/init.lua"
  end
  
  -- Add all plugin lua directories
  for _, dir in ipairs(vim.fn.glob(dpp_repos .. "/*/nvim-*/lua", 0, 1)) do
    package.path = package.path .. ";" .. dir .. "/?.lua;" .. dir .. "/?/init.lua"
  end
  for _, dir in ipairs(vim.fn.glob(dpp_repos .. "/*/*/lua", 0, 1)) do
    package.path = package.path .. ";" .. dir .. "/?.lua;" .. dir .. "/?/init.lua"
  end
end

-- Add paths immediately
add_dpp_lua_paths()

-- Also add on DppReady event (for plugins loaded later)
vim.api.nvim_create_autocmd("User", {
  pattern = "DppReady",
  once = true,
  callback = function()
    add_dpp_lua_paths()
    vim.notify("Lua paths updated for dpp plugins", vim.log.levels.INFO)
  end
})

-- Enable filetype and syntax early
vim.cmd("filetype indent plugin on")
vim.cmd("syntax enable")

-- Load basic Neovim settings (options, keymaps, autocmds)
local function load_basic_settings()
  local dpp_hooks_path = config_path .. '/dpp/hooks/'
  
  -- Load options
  local options_ok, _ = pcall(dofile, dpp_hooks_path .. 'options.lua')
  if not options_ok then
    vim.notify("Failed to load options.lua", vim.log.levels.WARN)
  end
  
  -- Load keymaps
  local keymaps_ok, _ = pcall(dofile, dpp_hooks_path .. 'keymaps.lua')
  if not keymaps_ok then
    vim.notify("Failed to load keymaps.lua", vim.log.levels.WARN)
  end
  
  -- Load autocmds
  local autocmds_ok, _ = pcall(dofile, dpp_hooks_path .. 'autocmds.lua')
  if not autocmds_ok then
    vim.notify("Failed to load autocmds.lua", vim.log.levels.WARN)
  end
end

-- Load basic settings immediately
load_basic_settings()

-- LSP設定はplugin/lsp.luaで自動的に読み込まれる

-- Force load dpp autoload functions
vim.cmd("runtime! autoload/dpp.vim")
vim.cmd("runtime! autoload/dpp/min.vim")

-- Initialize dpp.vim
local dpp_config = config_path .. "/config.ts"
local dpp_initialized = false

-- Check if dpp functions are available after loading
if vim.fn.exists('*dpp#min#load_state') == 1 then
  -- Try to load state (0 = success, 1 = failure)
  local load_result = vim.fn["dpp#min#load_state"](cache_path)
  
  if load_result == 0 then
    -- State loaded successfully
    dpp_initialized = true
    vim.notify("dpp state loaded successfully", vim.log.levels.INFO)
    
    -- Load core settings immediately
    local ok, core = pcall(require, "dpp.core")
    if ok and core.setup then
      core.setup()
    end
  else
    -- State not found or invalid, need to make state
    vim.notify("dpp state not found, will rebuild on DenopsReady", vim.log.levels.WARN)
    
    vim.api.nvim_create_autocmd("User", {
      pattern = "DenopsReady",
      once = true,
      callback = function()
        vim.notify("Building dpp state...", vim.log.levels.INFO)
        vim.fn["dpp#make_state"](cache_path, dpp_config)
      end,
    })
  end
else
  vim.notify("dpp#min#load_state not found. Check dpp.vim installation.", vim.log.levels.ERROR)
end

-- Load core settings after dpp state is built
vim.api.nvim_create_autocmd("User", {
  pattern = "Dpp:makeStatePost",
  callback = function()
    vim.notify("dpp state build completed", vim.log.levels.INFO)
    dpp_initialized = true
    
    -- Load basic configuration
    local ok, core = pcall(require, "dpp.core")
    if ok and core.setup then
      core.setup()
    end
  end,
})

-- User commands with initialization check
vim.api.nvim_create_user_command("DppInstall", function()
  if not dpp_initialized then
    vim.notify("dpp.vim is not initialized. Run :DppMakeState first", vim.log.levels.ERROR)
    return
  end
  vim.fn["dpp#async_ext_action"]("installer", "install")
end, {})

vim.api.nvim_create_user_command("DppUpdate", function(opts)
  if not dpp_initialized then
    vim.notify("dpp.vim is not initialized. Run :DppMakeState first", vim.log.levels.ERROR)
    return
  end
  vim.fn["dpp#async_ext_action"]("installer", "update", { names = opts.fargs })
end, { nargs = "*" })

vim.api.nvim_create_user_command("DppMakeState", function()
  vim.notify("Building dpp state...", vim.log.levels.INFO)
  vim.fn["dpp#make_state"](cache_path, dpp_config)
end, {})

-- Debug command to check dpp status
vim.api.nvim_create_user_command("DppStatus", function()
  print("dpp.vim status:")
  print("  Initialized: " .. tostring(dpp_initialized))
  print("  Cache path: " .. cache_path)
  print("  Config path: " .. dpp_config)
  print("  dpp#min#load_state exists: " .. vim.fn.exists('*dpp#min#load_state'))
  print("  dpp#make_state exists: " .. vim.fn.exists('*dpp#make_state'))
  
  if vim.fn.exists('*dpp#min#load_state') == 1 then
    local result = vim.fn["dpp#min#load_state"](cache_path)
    print("  load_state result: " .. result .. " (0=success, 1=failure)")
  end
end, {})
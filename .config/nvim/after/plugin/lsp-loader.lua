if vim.g.__lsp_hooks_loaded then return end
vim.g.__lsp_hooks_loaded = true

local cfg = vim.fn.stdpath('config')
local path = (vim.fs and vim.fs.joinpath or function(a,b) return a..'/'..b end)(cfg, 'dpp/hooks/lsp.lua')

if vim.loop and vim.loop.fs_stat(path) then
  vim.notify("⏬ loading: " .. path, vim.log.levels.INFO)
  local ok, err = pcall(dofile, path)
  if ok then
    vim.notify("✅ loaded: dpp/hooks/lsp.lua", vim.log.levels.INFO)
  else
    vim.notify("❌ failed: " .. tostring(err), vim.log.levels.ERROR)
  end
else
  vim.notify("❔ not found: " .. path, vim.log.levels.WARN)
end

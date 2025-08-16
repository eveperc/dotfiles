-- =====================================================================
-- Core configuration loader for dpp.vim
-- =====================================================================

local M = {}

M.setup = function()
  -- Load modules in order
  local modules = {
    "dpp.options",    -- Neovim options
    "dpp.keymaps",    -- Key mappings
    "dpp.autocmds",   -- Autocommands
  }
  
  for _, module in ipairs(modules) do
    local ok, err = pcall(require, module)
    if not ok then
      vim.notify("Failed to load " .. module .. ": " .. tostring(err), vim.log.levels.ERROR)
    end
  end
end

return M
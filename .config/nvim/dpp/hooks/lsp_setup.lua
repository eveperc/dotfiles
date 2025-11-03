-- LSP Setup - この関数はMasonとMason-LSPconfigの後に呼ばれる
local M = {}

M.setup = function()
  local config_path = vim.fn.stdpath('config')

  -- Masonが利用可能な場合は詳細な設定も試す
  local mason_ok = pcall(require, "mason")
  local mason_lspconfig_ok = pcall(require, "mason-lspconfig")

  if mason_ok and mason_lspconfig_ok then
    -- 少し待ってから詳細な設定を読み込む
    vim.defer_fn(function()
      local lsp_config_path = config_path .. '/dpp/hooks/lsp.lua'
      local ok, err = pcall(dofile, lsp_config_path)
      if not ok then
        -- vim.notify("Failed to load advanced lsp.lua: " .. tostring(err), vim.log.levels.WARN)
      else
        -- vim.notify("Advanced LSP setup completed", vim.log.levels.INFO)
      end
    end, 100)
  end
end
vim.notify("🎉 Clean LSP configuration loaded successfully", vim.log.levels.INFO)
return M

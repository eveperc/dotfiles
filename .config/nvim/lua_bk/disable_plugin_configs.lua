-- dpp.vimモードで既存のプラグイン設定を無効化
local M = {}

M.disable = function()
  -- plugin/ディレクトリのファイルを無効化
  vim.g.loaded_plugin_configs = true
  
  -- プラグイン設定の自動読み込みを防ぐ
  local plugin_dir = vim.fn.stdpath('config') .. '/plugin'
  local files = vim.fn.glob(plugin_dir .. '/*.lua', false, true)
  
  for _, file in ipairs(files) do
    local basename = vim.fn.fnamemodify(file, ':t:r')
    -- グローバル変数でロード済みとマーク
    vim.g['loaded_' .. basename] = true
  end
end

return M
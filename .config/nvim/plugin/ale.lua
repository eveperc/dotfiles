-- ALEの基本設定
vim.g.ale_enabled = 1
vim.g.ale_fix_on_save = 1

-- PHP特有の設定
vim.g.ale_php_phpcs_standard = 'PSR12'
vim.g.ale_php_phpcbf_standard = 'PSR12' -- phpcbfの標準も設定
vim.g.ale_php_phpcs_use_global = 1
vim.g.ale_php_phpcbf_use_global = 1     -- phpcbfもグローバルを使用
-- Prettierの設定
vim.g.ale_javascript_prettier_executable = 'prettier'
vim.g.ale_javascript_prettier_use_local_config = 1

vim.g.ale_fixers = {
  css = { 'prettier' },
  scss = { 'prettier' },
  javascript = { 'prettier' },
  typescript = { 'prettier' },
  vue = { 'prettier' },
  php = { 'phpcbf' },
}

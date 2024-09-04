-- ALEを有効
vim.g.ale_enabled = 1

vim.g.ale_fix_on_save = 1

vim.g.ale_fixers = {
  css = { 'prettier' },
  scss = { 'prettier' },
  javascript = { 'prettier' },
  typescript = { 'prettier' },
  vue = { 'prettier' },
  -- php = { 'php_cs_fixer' },
  php = { 'phpcbf' },
}
--
--
-- PHP
vim.g.ale_php_phpcs_standard = 'PSR12'
vim.g.ale_php_phpcsf_standard = 'PSR12'
vim.g.ale_php_phpcbf_standard = 'PSR12'
vim.g.ale_php_phpcs_use_global = 1

-- vim.g.ale_php_cs_fixer_use_global = 1
-- vim.g.ale_php_php_cs_fixer_config = '.php-cs-fixer.php'

vim.g.ale_sign_column_always = 1
-- --

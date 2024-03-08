-- ALEを有効
vim.g.ale_enabled = 1

vim.g.ale_fixers = {
  css = { 'prettier' },
  scss = { 'prettier' },
  javascript = { 'prettier' },
  typescript = { 'prettier' },
  vue = { 'prettier' },
  php = { 'php_cs_fixer' },
}


-- PHP
vim.g.ale_php_phpcs_standard = 'PSR2'
vim.g.ale_php_phpcsf_standard = 'PSR2'
vim.g.ale_php_phpcs_use_global = 1
vim.g.ale_sign_column_always = 1


vim.g.ale_fix_on_save = 1

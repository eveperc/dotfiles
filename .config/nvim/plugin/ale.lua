-- ALEを有効
vim.g.ale_enabled = 1

-- Prettierをフォーマッタとして設定
vim.g.ale_fixers = {
  css = { 'prettier' },
  scss = { 'prettier' },
}

vim.g.ale_fix_on_save = 1
-- local status, ale = pcall(require, 'ale')
-- if (not status) then return end
--
-- ale.setup {
--   fix_on_save = true,
--   fixers = {
--     ['css'] = { 'prettier' },
--     ['scss'] = { 'prettier' },
--   }
-- }

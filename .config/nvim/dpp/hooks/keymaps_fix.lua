-- Key mapping fixes for conflicting plugins
-- This file handles custom keymaps to avoid conflicts

-- vim-sandwich のデフォルトマッピングを無効化
vim.g.sandwich_no_default_key_mappings = 1

-- vim-sandwich のカスタムマッピング
vim.api.nvim_set_keymap('n', 'sa', '<Plug>(sandwich-add)', {})
vim.api.nvim_set_keymap('x', 'sa', '<Plug>(sandwich-add)', {})
vim.api.nvim_set_keymap('o', 'sa', '<Plug>(sandwich-add)', {})

vim.api.nvim_set_keymap('n', 'sd', '<Plug>(sandwich-delete)', {})
vim.api.nvim_set_keymap('x', 'sd', '<Plug>(sandwich-delete)', {})

vim.api.nvim_set_keymap('n', 'sr', '<Plug>(sandwich-replace)', {})
vim.api.nvim_set_keymap('x', 'sr', '<Plug>(sandwich-replace)', {})

vim.api.nvim_set_keymap('n', 'sdb', '<Plug>(sandwich-delete-auto)', {})
vim.api.nvim_set_keymap('n', 'srb', '<Plug>(sandwich-replace-auto)', {})

-- substitute.nvim のマッピング
vim.keymap.set("n", "ss", require('substitute').operator, { noremap = true })
vim.keymap.set("n", "sh", require('substitute').line, { noremap = true })
vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })

-- hop.nvim のマッピング（sではなく別のキーを使用）
vim.keymap.set('n', '<leader>hw', ':HopWord<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>hl', ':HopLine<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>hc', ':HopChar1<CR>', { noremap = true, silent = true })
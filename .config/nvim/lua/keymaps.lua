local opts = { noremap = true, silent = true }
local map_opts = { noremap = true }
local term_opts = { silent = true }

--local keymap = vim.keymap
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

keymap('n', '<leader><leader>', ':<C-u>cd %:h<CR>', map_opts)
keymap('n', '<leader>w', ':<C-u>w<CR>', map_opts)
keymap('n', '<leader>q', ':<C-u>bd<CR>', map_opts)
keymap('n', '<C-l>', ':<C-u>bnext<CR>', opts)
keymap('n', '<C-h>', ':<C-u>bprevious<CR>', opts)
keymap('n', 'j', 'gj', map_opts)
keymap('n', 'k', 'gk', map_opts)
keymap('i', 'jj', '<ESC>', term_opts)
keymap('n', '<C-W>+', ':<C-u>resize +5<CR>', term_opts)
keymap('n', '<C-W>-', ':<C-u>resize -5<CR>', term_opts)
keymap('n', '<C-W>>', ':<C-u>vertical resize +10<CR>', term_opts)
keymap('n', '<C-W><', ':<C-u>vertical resize -10<CR>', term_opts)
keymap('n', '<ESC><ESC>', ':nohlsearch<CR>', term_opts)
keymap('t', '<ESC>', '<C-\\><C-n>', term_opts)
keymap('t', '<C-W>j', '<CMD>wincmd j<CR>', term_opts)
keymap('t', '<C-W>k', '<CMD>wincmd k<CR>', term_opts)
keymap('t', '<C-W>h', '<CMD>wincmd h<CR>', term_opts)
keymap('t', '<C-W>l', '<CMD>wincmd l<CR>', term_opts)
-- 'ibhagwan/fzf-lua' ----------------------------------------------------------
keymap('n', '<leader>e', "<cmd>lua require('fzf-lua').files()<CR>", opts)
keymap('n', '<leader>g', "<cmd>lua require('fzf-lua').git_status()<CR>", opts)
keymap('n', '<leader>p', "<cmd>lua require('fzf-lua').live_grep()<CR>", opts)
keymap('n', '<leader>h', "<cmd>lua require('fzf-lua').oldfiles()<CR>", opts)
keymap('n', '<leader>b', "<cmd>lua require('fzf-lua').buffers()<CR>", opts)
keymap('n', '<leader>c', "<cmd>lua require('neoclip.fzf')()<CR>", opts)
-- 'tpope/vim-fugitive' --------------------------------------------------------
keymap('n', '<leader>GG', ':<C-u>Git<CR>', map_opts)
keymap('n', '<leader>GC', ':<C-u>Git commit<CR>', map_opts)
keymap('n', '<leader>GP', ':<C-u>Git push<CR>', map_opts)
keymap('n', '<leader>GL', ':<C-u>Git log --oneline<CR>', map_opts)
keymap('n', '<leader>GD', ':<C-u>vert Gdiffsplit !~1', map_opts)
-- 'tamago324/lir.nvim' --------------------------------------------------------
keymap('n', '<leader>l', "<cmd>lua require'lir.float'.toggle()<CR>", opts)
-- 'hop' --------------------------------------------------------
keymap('n', '<C-f>', "<cmd>HopWord<CR>", opts)
-- 'akinsho/toggleterm.nvim' --------------------------------------------------------
keymap('n', '<leader>t', '<cmd>ToggleTerm<CR>', opts)
keymap('n', '<leader>lg', '<cmd>lua _lazygit_toggle()<CR>', opts)
-- ThePrimeagen/harpoon --------------------------------------------------------
keymap('n', '<leader>m', ':lua require("harpoon.mark").add_file()<CR>', opts)
keymap('n', '<leader>k', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', opts)
keymap('n', '<C-K>', ':lua require("harpoon.ui").nav_next()<CR>', opts)
keymap('n', '<C-J>', ':lua require("harpoon.ui").nav_prev()<CR>', opts)
-- 'mfussenegger/nvim-treehopper' --------------------------------------------------------
keymap('v', 'm', ':<C-U>lua require("tsht").nodes()<CR>', opts)
-- 'David-Kunz/treesitter-unit' --------------------------------------------------------
keymap('x', 'iu', ':lua require"treesitter-unit".select()<CR>', opts)
keymap('x', 'au', ':lua require"treesitter-unit".select(true)<CR>', opts)
keymap('o', 'iu', ':<c-u>lua require"treesitter-unit".select()<CR>', opts)
keymap('o', 'au', ':<c-u>lua require"treesitter-unit".select(true)<CR>', opts)

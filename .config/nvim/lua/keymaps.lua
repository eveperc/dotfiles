local vim = vim
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

keymap('t', '<C-W>j', '<CMD>wincmd j<CR>', term_opts)
keymap('t', '<C-W>k', '<CMD>wincmd k<CR>', term_opts)
keymap('t', '<C-W>h', '<CMD>wincmd h<CR>', term_opts)
keymap('t', '<C-W>l', '<CMD>wincmd l<CR>', term_opts)
-- 'ibhagwan/fzf-lua' ----------------------------------------------------------
keymap('n', '<leader>e', "<cmd>lua require('fzf-lua').files()<cr>", opts)
keymap('n', '<leader>p', "<cmd>lua require('fzf-lua').live_grep()<cr>", opts)
keymap('n', '<leader>b', "<cmd>lua require('fzf-lua').buffers()<cr>", opts)
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
-- 'mfussenegger/nvim-treehopper' --------------------------------------------------------
keymap('v', 'm', ':<C-U>lua require("tsht").nodes()<CR>', opts)
-- 'David-Kunz/treesitter-unit' --------------------------------------------------------
keymap('x', 'iu', ':lua require"treesitter-unit".select()<CR>', opts)
keymap('x', 'au', ':lua require"treesitter-unit".select(true)<CR>', opts)
keymap('o', 'iu', ':<c-u>lua require"treesitter-unit".select()<CR>', opts)
keymap('o', 'au', ':<c-u>lua require"treesitter-unit".select(true)<CR>', opts)
-- 'vim-gitgutter'--------------------------------------------------------
keymap('n', '<leader>gd', "<cmd>GitGutterDiffOrig<CR>", opts)
keymap('n', '<leader>gf', "<cmd>GitGutterFold<CR>", opts)
-- 'nvim-dap-ui'--------------------------------------------------------
keymap('n', '<leader>db', ':DapToggleBreakpoint<CR>', opts)
keymap('n', '<leader>d', ':lua require("dapui").toggle()<CR>', opts)
-- 'David-Kunz/vim-edgemotion' --------------------------------------------------------
keymap('n', '<C-j>', '<Plug>(edgemotion-j)', opts)
keymap('n', '<C-k>', '<Plug>(edgemotion-k)', opts)
-- 'machakann/vim-columnmove'--------------------------------------------------------
keymap('n', '<C-m>', '<Plug>(columnmove-f)', opts)
keymap('n', '<C-n>', '<Plug>(columnmove-F)', opts)
-- navbuddy
keymap('n', '<leader>n', '<cmd>Navbuddy<CR>', opts)
-- nvim-alt-substitute
vim.keymap.set({ "n", "x" }, "<leader>s", [[:S ///g<Left><Left><Left>]], { desc = "󱗘 :AltSubstitute" })
-- advanced-git-search
keymap('n', '<leader>gs', "<cmd>Telescope advanced_git_search diff_commit_file<CR>", opts)
-- folke/trouble.nvim
keymap('n', '<leader>xx', "<cmd>TroubleToggle<CR>", opts)

-- CopilotChat.nvim --------------------------------------------------------
-- バッファの内容全体を使って Copilot とチャットする
function CopilotChatBuffer()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
  end
end
-- telescope を使ってアクションプロンプトを表示する
function ShowCopilotChatActionPrompt()
  local actions = require("CopilotChat.actions")
  require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
end

-- キーマッピング
keymap('n', '<leader>ccq', ':lua CopilotChatBuffer()<CR>', opts)
-- <leader>ccp (Copilot Chat Prompt の略) でアクションプロンプトを表示する
keymap('n', '<leader>ccp', ':lua ShowCopilotChatActionPrompt()<CR>', opts)
-- ビジュアルモードで選択した範囲を使って Copilot とチャットする
keymap('v', '<leader>ccq', ':lua CopilotChat.ask(vim.fn.getreg("v"), { selection = require("CopilotChat.select").visual })<CR>', opts)

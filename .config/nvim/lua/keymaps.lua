--[[
keymaps.lua - Neovimのキーマッピング設定

このファイルでは以下のカテゴリのキーマッピングを定義しています：
1. 基本的なエディタ操作 (ファイル保存、バッファ切り替えなど)
2. LSP関連の操作 (定義ジャンプ、ホバー、コードアクション)
3. プラグイン固有の機能
4. 大西配列用のキーマッピング

キーマッピングの命名規則：
- <leader> キーはスペースに設定
- プラグイン関連のマッピングは <leader> + アルファベットで設定
- モード別のマッピング (normal, insert, visual, terminal) を明確に区分

注意：
- opts = { noremap = true, silent = true } - 再マッピング無効、出力非表示
- map_opts = { noremap = true } - 再マッピング無効
- term_opts = { silent = true } - ターミナルモード用、出力非表示
--]]

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

-- モード一覧
--   normal_mode = 'n' - ノーマルモード
--   insert_mode = 'i' - 挿入モード
--   visual_mode = 'v' - ビジュアルモード
--   visual_block_mode = 'x' - ビジュアルブロックモード
--   term_mode = 't' - ターミナルモード
--   command_mode = 'c' - コマンドモード

-- 基本的なエディタ操作
-- 現在のファイルのディレクトリに移動
keymap('n', '<leader><leader>', ':<C-u>cd %:h<CR>', map_opts)
keymap('n', '<leader>w', ':<C-u>w<CR>', map_opts)
keymap('n', '<leader>q', ':<C-u>bd<CR>', map_opts)
keymap('n', '<C-l>', ':<C-u>bnext<CR>', opts)
keymap('n', '<C-h>', ':<C-u>bprevious<CR>', opts)
keymap('n', 'j', 'gj', map_opts)
-- keymap('n', 'k', 'gk', map_opts)
keymap('i', 'jj', '<ESC>', term_opts)
keymap('n', '<C-W>+', ':<C-u>resize +5<CR>', term_opts)
keymap('n', '<C-W>-', ':<C-u>resize -5<CR>', term_opts)
keymap('n', '<C-W>>', ':<C-u>vertical resize +10<CR>', term_opts)
keymap('n', '<C-W><', ':<C-u>vertical resize -10<CR>', term_opts)

-- LSP関連のキーマッピング
-- ホバードキュメントの表示
vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>")

  vim.keymap.set('n', 'gr', '<cmd>Lspsaga finder<CR>')
  vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
  vim.keymap.set("n", "ga", "<cmd>Lspsaga code_action<CR>")
  vim.keymap.set("n", "gn", "<cmd>Lspsaga rename<CR>")
  vim.keymap.set("n", "ge", "<cmd>Lspsaga show_line_diagnostics<CR>")
  vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>")
  vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
-- keymap('t', '<C-W>j', '<CMD>wincmd j<CR>', term_opts)
-- keymap('t', '<C-W>k', '<CMD>wincmd k<CR>', term_opts)
-- keymap('t', '<C-W>h', '<CMD>wincmd h<CR>', term_opts)
-- keymap('t', '<C-W>l', '<CMD>wincmd l<CR>', term_opts)
-- 'ibhagwan/fzf-lua' ----------------------------------------------------------
-- fzf-lua (ファジーファインダー) のキーマッピング
keymap('n', '<leader>e', "<cmd>lua require('fzf-lua').files()<cr>", opts)
keymap('n', '<leader>p', "<cmd>lua require('fzf-lua').live_grep()<cr>", opts)
keymap('n', '<leader>b', "<cmd>lua require('fzf-lua').buffers()<cr>", opts)
-- 'tpope/vim-fugitive' --------------------------------------------------------
-- Fugitive (Git操作) のキーマッピング
keymap('n', '<leader>GG', ':<C-u>Git<CR>', map_opts)
keymap('n', '<leader>GC', ':<C-u>Git commit<CR>', map_opts)
keymap('n', '<leader>GP', ':<C-u>Git push<CR>', map_opts)
keymap('n', '<leader>GL', ':<C-u>Git log --oneline<CR>', map_opts)
keymap('n', '<leader>GD', ':<C-u>vert Gdiffsplit !~1', map_opts)
-- 'tamago324/lir.nvim' --------------------------------------------------------
keymap('n', '<leader>l', "<cmd>lua require'lir.float'.toggle()<CR>", opts)
-- 'hop' --------------------------------------------------------
keymap('n', '<C-f>', "<cmd>HopWord<CR>", opts)
-- toggleterm (ターミナル操作) のキーマッピング
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

-- CopilotChat.nvim (AIアシスタント) のキーマッピング
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
keymap('v', '<leader>ccq',
  ':lua CopilotChat.ask(vim.fn.getreg("v"), { selection = require("CopilotChat.select").visual })<CR>', opts)

-- 大西配列用のキーマッピング（ホームポジションでの移動効率化）
-- k: 左移動 (h)
-- t: 下移動 (j)
-- n: 上移動 (k)
-- s: 右移動 (l)
keymap('n', 'k', 'h', map_opts)
keymap('n', 't', 'j', map_opts)
keymap('n', 'n', 'k', map_opts)
-- keymap('n', 's', 'l', map_opts)
-- タイムアウトを設定して即座に右移動するように
vim.keymap.set('n', 's', 'l', { noremap = true, nowait = true })
vim.keymap.set('v', 's', 'l', { noremap = true, nowait = true })
keymap('v', 'k', 'h', map_opts)
keymap('v', 't', 'j', map_opts)
keymap('v', 'n', 'k', map_opts)
keymap('v', 's', 'l', map_opts)
keymap('t', '<C-W>k', '<CMD>wincmd h<CR>', term_opts)
keymap('t', '<C-W>t', '<CMD>wincmd j<CR>', term_opts)
keymap('t', '<C-W>n', '<CMD>wincmd k<CR>', term_opts)
keymap('t', '<C-W>s', '<CMD>wincmd l<CR>', term_opts)
keymap('n', '<C-s>', ':<C-u>bnext<CR>', opts)
keymap('n', '<C-k>', ':<C-u>bprevious<CR>', opts)
-- 検索結果の移動を-キーに割り当て
keymap('n', '-', 'n', map_opts) -- 次の検索結果へ
keymap('n', '_', 'N', map_opts) -- 前の検索結果へ（Shift + -）

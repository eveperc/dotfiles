-- keymaps.lua - Neovimのキーマッピング設定
-- dpp.vimで使用するための設定ファイル

local vim = vim
local opts = { noremap = true, silent = true }
local map_opts = { noremap = true }
local term_opts = { silent = true }
local keymap = vim.api.nvim_set_keymap

-- 1. 基本設定
--------------------------------------------------------------------------------
-- スペースをLeaderキーとして設定
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 2. エディタの基本操作
--------------------------------------------------------------------------------
-- 現在のファイルのディレクトリに移動
keymap('n', '<leader><leader>', ':<C-u>cd %:h<CR>', map_opts)
keymap('n', '<leader>w', ':<C-u>w<CR>', map_opts)
keymap('n', '<leader>q', ':<C-u>bd<CR>', map_opts)
keymap('n', '<C-l>', ':<C-u>bnext<CR>', opts)
keymap('n', '<C-h>', ':<C-u>bprevious<CR>', opts)
keymap('n', 'j', 'gj', map_opts)
keymap('i', 'jj', '<ESC>', term_opts)
keymap('n', '<C-W>+', ':<C-u>resize +5<CR>', term_opts)
keymap('n', '<C-W>-', ':<C-u>resize -5<CR>', term_opts)
keymap('n', '<C-W>>', ':<C-u>vertical resize +10<CR>', term_opts)
keymap('n', '<C-W><', ':<C-u>vertical resize -10<CR>', term_opts)

-- 3. LSP (Language Server Protocol)
--------------------------------------------------------------------------------
-- LSPのキーマッピングは各バッファのon_attachで設定されるため、ここではグローバルな設定のみ
-- 詳細は dpp/hooks/lsp.lua の on_attach 関数を参照
-- -- キーマッピング設定
  vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>")

  vim.keymap.set('n', 'gr', '<cmd>Lspsaga finder<CR>')
  vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
  vim.keymap.set("n", "ga", "<cmd>Lspsaga code_action<CR>")
  vim.keymap.set("n", "gn", "<cmd>Lspsaga rename<CR>")
  vim.keymap.set("n", "ge", "<cmd>Lspsaga show_line_diagnostics<CR>")
  vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>")
  vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")

-- 4. プラグイン固有の機能
--------------------------------------------------------------------------------
-- fzf-lua (ファジーファインダー) のキーマッピング - コマンド経由で呼び出し
keymap('n', '<leader>e', '<cmd>FzfLua files<cr>', opts)
keymap('n', '<leader>p', '<cmd>FzfLua live_grep<cr>', opts)
keymap('n', '<leader>b', '<cmd>FzfLua buffers<cr>', opts)

-- Fugitive (Git操作) のキーマッピング
keymap('n', '<leader>GG', ':<C-u>Git<CR>', map_opts)
keymap('n', '<leader>GC', ':<C-u>Git commit<CR>', map_opts)
keymap('n', '<leader>GP', ':<C-u>Git push<CR>', map_opts)
keymap('n', '<leader>GL', ':<C-u>Git log --oneline<CR>', map_opts)
keymap('n', '<leader>GD', ':<C-u>vert Gdiffsplit !~1', map_opts)

-- lir.nvim (ファイラー) のキーマッピング
keymap('n', '<leader>l', "<cmd>lua require'lir.float'.toggle()<CR>", opts)

-- hop (カーソル移動) のキーマッピング
keymap('n', '<C-f>', "<cmd>HopWord<CR>", opts)

-- toggleterm (ターミナル操作) のキーマッピング
keymap('n', '<leader>t', '<cmd>ToggleTerm<CR>', opts)
-- lazygit_toggleは別途定義が必要なので一旦コメントアウト
-- keymap('n', '<leader>lg', '<cmd>lua _lazygit_toggle()<CR>', opts)

-- treehopper のキーマッピング - TSHopコマンド経由に変更
keymap('v', 'm', ':<C-U>TSHop<CR>', opts)

-- treesitter-unit のキーマッピング - 遅延評価のため関数でラップ
keymap('x', 'iu', ':<c-u>lua pcall(function() require("treesitter-unit").select() end)<CR>', opts)
keymap('x', 'au', ':<c-u>lua pcall(function() require("treesitter-unit").select(true) end)<CR>', opts)
keymap('o', 'iu', ':<c-u>lua pcall(function() require("treesitter-unit").select() end)<CR>', opts)
keymap('o', 'au', ':<c-u>lua pcall(function() require("treesitter-unit").select(true) end)<CR>', opts)

-- gitgutter のキーマッピング
keymap('n', '<leader>gd', "<cmd>GitGutterDiffOrig<CR>", opts)
keymap('n', '<leader>gf', "<cmd>GitGutterFold<CR>", opts)

-- nvim-dap-ui のキーマッピング
keymap('n', '<leader>db', '<cmd>DapToggleBreakpoint<CR>', opts)
keymap('n', '<leader>d', '<cmd>lua pcall(function() require("dapui").toggle() end)<CR>', opts)

-- edgemotion のキーマッピング
keymap('n', '<C-j>', '<Plug>(edgemotion-j)', opts)
keymap('n', '<C-k>', '<Plug>(edgemotion-k)', opts)

-- columnmove のキーマッピング
keymap('n', '<C-m>', '<Plug>(columnmove-f)', opts)
keymap('n', '<C-n>', '<Plug>(columnmove-F)', opts)

-- navbuddy のキーマッピング
keymap('n', '<leader>n', '<cmd>Navbuddy<CR>', opts)

-- nvim-alt-substitute のキーマッピング
vim.keymap.set({ "n", "x" }, "<leader>s", [[:S ///g<Left><Left><Left>]], { desc = "󱗘 :AltSubstitute" })

-- advanced-git-search のキーマッピング
keymap('n', '<leader>gs', "<cmd>Telescope advanced_git_search diff_commit_file<CR>", opts)

-- trouble.nvim のキーマッピング
keymap('n', '<leader>xx', '<cmd>Trouble<CR>', opts)

-- CopilotChat.nvim (AIアシスタント) のキーマッピング
-- バッファの内容全体を使って Copilot とチャットする
function _G.CopilotChatBuffer()
  local ok, chat = pcall(require, "CopilotChat")
  if ok then
    local input = vim.fn.input("Quick Chat: ")
    if input ~= "" then
      local select_ok, select = pcall(require, "CopilotChat.select")
      if select_ok then
        chat.ask(input, { selection = select.buffer })
      end
    end
  end
end

-- telescope を使ってアクションプロンプトを表示する
function _G.ShowCopilotChatActionPrompt()
  local ok, actions = pcall(require, "CopilotChat.actions")
  if ok then
    local telescope_ok = pcall(require, "CopilotChat.integrations.telescope")
    if telescope_ok then
      require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
    end
  end
end

-- キーマッピング - コマンド経由で呼び出し
keymap('n', '<leader>ct', '<cmd>CopilotChat<CR>', opts)
keymap('n', '<leader>at', '<cmd>AvanteToggle<CR>', opts)
keymap('n', '<leader>ccq', '<cmd>lua _G.CopilotChatBuffer()<CR>', opts)
keymap('n', '<leader>ccp', '<cmd>lua _G.ShowCopilotChatActionPrompt()<CR>', opts)
-- ビジュアルモードは遅延評価
keymap('v', '<leader>ccq',
  '<cmd>lua pcall(function() local c = require("CopilotChat"); local s = require("CopilotChat.select"); c.ask(vim.fn.getreg("v"), { selection = s.visual }) end)<CR>', opts)

-- 5. キーボードレイアウト (大西配列)
--------------------------------------------------------------------------------
-- 大西配列用のキーマッピング（ホームポジションでの移動効率化）
-- k: 左移動 (h)
-- t: 下移動 (j)
-- n: 上移動 (k)
-- s: 右移動 (l)
keymap('n', 'k', 'h', map_opts)
keymap('n', 't', 'j', map_opts)
keymap('n', 'n', 'k', map_opts)
-- タイムアウトを設定して即座に右移動するように
keymap('n', 's', 'l', { noremap = true, nowait = true })
keymap('v', 's', 'l', { noremap = true, nowait = true })

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

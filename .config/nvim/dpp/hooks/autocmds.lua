-- autocmds.lua - Neovimの自動コマンド設定
-- dpp.vimで使用するための設定ファイル

local vim = vim
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Filetype検出を有効化
vim.cmd('filetype plugin indent on')

-- ファイル保存時に行末の空白文字を自動的に削除
autocmd("BufWritePre", {
  pattern = "*",
  command = ":%s/\\s\\+$//e",
})

-- 新しい行を追加した時に自動的にコメントを継続しない設定
autocmd("BufEnter", {
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
})

-- ファイルを開いた時に、前回終了時のカーソル位置を復元
autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

-- ターミナルを開いた時に自動的にインサートモードに入る
vim.cmd 'autocmd TermOpen * startinsert'

-- WSL環境でのクリップボード連携設定
vim.cmd [[
if system('uname -a | grep microsoft') != ''
    augroup myYank
      autocmd!
      autocmd TextYankPost * :call system('clip.exe', @")
    augroup END
endif"
]]

-- QuickScope プラグインのハイライト色設定
vim.cmd [[
  augroup qs_colors
    autocmd!
    autocmd ColorScheme * highlight QuickScopePrimary guifg='#40E0D0' gui=underline ctermfg=155 cterm=underline
    autocmd ColorScheme * highlight QuickScopeSecondary guifg='#4169E1' gui=underline ctermfg=81 cterm=underline
  augroup END
]]

-- ファイル保存時のフォーマット設定（現在コメントアウト中）
vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = "FormatOnSave",
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= 'css' and vim.bo.filetype ~= 'scss' then
      vim.lsp.buf.format()
    end
  end,
})

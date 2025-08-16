--[[
autocmds.lua - Neovimの自動コマンド設定

このファイルでは以下のカテゴリの自動コマンドを定義しています：
1. ファイル編集時の自動整形（空白文字の削除など）
2. バッファ操作時の動作（自動コメント無効化など）
3. ファイルを開いた時の状態復元
4. ターミナル関連の設定
5. クリップボード連携（WSL環境用）
6. カラースキーム関連の設定

主な設定項目：
- BufWritePre: ファイル保存時の処理
- BufEnter: バッファ切り替え時の処理
- BufReadPost: ファイルを開いた後の処理
- TermOpen: ターミナルを開いた時の処理
- TextYankPost: テキストヤンク(コピー)後の処理

注意：
- WSL環境での特別な設定あり（クリップボード連携）
- カラースキーム変更時の特別な強調表示設定あり
--]]

local vim = vim

-- 自動コマンドグループを作成/取得する関数
local augroup = vim.api.nvim_create_augroup
-- 自動コマンドを作成する関数
local autocmd = vim.api.nvim_create_autocmd

-- ファイル保存時に行末の空白文字を自動的に削除
autocmd("BufWritePre", {
  pattern = "*",
  command = ":%s/\\s\\+$//e",
})

-- 新しい行を追加した時に自動的にコメントを継続しない設定
-- fo-=c: 文章整形の際にコメントリーダーを挿入しない
-- fo-=r: <Enter>押下時にコメントを自動挿入しない
-- fo-=o: o/O押下時にコメントを自動挿入しない
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
-- -- eqaul to below setting
-- vim.cmd [[
-- if executable('fcitx5')
--   let g:fcitx_state = 1
--   augroup fcitx_savestate
--     autocmd!
--     autocmd InsertLeave * let g:fcitx_state = str2nr(system('fcitx5-remote'))
--     autocmd InsertLeave * call system('fcitx5-remote -c')
--     autocmd InsertEnter * call system(g:fcitx_state == 1 ? 'fcitx5-remote -c': 'fcitx5-remote -o')
--   augroup END
-- endif
-- ]]

-- WSL環境でのクリップボード連携設定
-- ヤンクしたテキストをWindows側のクリップボードにコピー
vim.cmd [[
if system('uname -a | grep microsoft') != ''
    augroup myYank
      autocmd!
      autocmd TextYankPost * :call system('clip.exe', @")
    augroup END
endif"
]]

-- QuickScope プラグインのハイライト色設定
-- Primary: 最初のマッチを水色でハイライト
-- Secondary: 二番目以降のマッチを青色でハイライト
vim.cmd [[
  augroup qs_colors
    autocmd!
    autocmd ColorScheme * highlight QuickScopePrimary guifg='#40E0D0' gui=underline ctermfg=155 cterm=underline
    autocmd ColorScheme * highlight QuickScopeSecondary guifg='#4169E1' gui=underline ctermfg=81 cterm=underline
  augroup END
]]

-- キーマッピングのオプション設定
-- noremap: 再マッピングを無効化
-- silent: コマンドラインでの表示を抑制
local opts = { noremap = true, silent = true }

-- ファイル保存時のフォーマット設定（現在コメントアウト中）
-- CSS/SCSS以外のファイルに対してLSPフォーマッタを実行
-- vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = "FormatOnSave",
--   pattern = "*",
--   callback = function()
--     if vim.bo.filetype ~= 'css' and vim.bo.filetype ~= 'scss' then
--       vim.lsp.buf.format()
--     end
--   end,
-- })

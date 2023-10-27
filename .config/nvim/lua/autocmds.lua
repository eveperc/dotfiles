local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- Remove whitespace on save
autocmd("BufWritePre", {
    pattern = "*",
    command = ":%s/\\s\\+$//e",
})

-- Don't auto commenting new lines
autocmd("BufEnter", {
    pattern = "*",
    command = "set fo-=c fo-=r fo-=o",
})

-- Restore cursor location when file is opened
autocmd({ "BufReadPost" }, {
    pattern = { "*" },
    callback = function()
        vim.api.nvim_exec('silent! normal! g`"zv', false)
    end,
})


-- eqaul to below setting
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

-- クリップボード
vim.cmd [[
if system('uname -a | grep microsoft') != ''
    augroup myYank
      autocmd!
      autocmd TextYankPost * :call system('clip.exe', @")
    augroup END
endif"
]]

vim.cmd [[
  augroup qs_colors
    autocmd!
    autocmd ColorScheme * highlight QuickScopePrimary guifg='#40E0D0' gui=underline ctermfg=155 cterm=underline
    autocmd ColorScheme * highlight QuickScopeSecondary guifg='#4169E1' gui=underline ctermfg=81 cterm=underline
  augroup END
]]

-- キーマッピングのオプション
local opts = { noremap = true, silent = true }

-- BufWritePreイベントでのキーマッピング設定
vim.cmd([[
augroup FormatOnSave
    autocmd!
    autocmd BufWritePre * lua vim.lsp.buf.format()
augroup END
]])

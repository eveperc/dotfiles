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
-- eqaul to below setting
vim.cmd [[
if executable('fcitx5')
  let g:fcitx_state = 1
  augroup fcitx_savestate
    autocmd!
    autocmd InsertLeave * let g:fcitx_state = str2nr(system('fcitx5-remote'))
    autocmd InsertLeave * call system('fcitx5-remote -c')
    autocmd InsertEnter * call system(g:fcitx_state == 1 ? 'fcitx5-remote -c': 'fcitx5-remote -o')
  augroup END
endif
]]

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
    autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
    autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
  augroup END
]]

-- vim.cmd [[
--   augroup ChangeBackGround
--     autocmd!
--     " フォーカスした時(colorscheme準拠に切替)
--     autocmd FocusGained * hi Normal ctermbg=234 " :hi Normalで取得した値
--     autocmd FocusGained * hi NonText ctermbg=234 " :hi NonTextで取得した値
--     autocmd FocusGained * hi SpecialKey ctermbg=234 " :hi SpecialKeyで取得した値
--     autocmd FocusGained * hi EndOfBuffer ctermbg=none " EndOfBufferの設定は恐らくclearなのでnoneを入れる
--     " フォーカスを外した時（フォーカスしていない時の背景色に切替)
--     autocmd FocusLost * execute('hi Normal '.g:InactiveBackGround)
--     autocmd FocusLost * execute('hi NonText '.g:InactiveBackGround)
--     autocmd FocusLost * execute('hi SpecialKey '.g:InactiveBackGround)
--     autocmd FocusLost * execute('hi EndOfBuffer '.g:InactiveBackGround)
--   augroup END
-- ]]

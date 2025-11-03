local vim = vim
-- colorscheme -----------------------------------------------------------------
vim.cmd 'colorscheme everforest'
-- vim.cmd 'colorscheme zephyrium'
-- vim.cmd 'colorscheme monochrome'

-- フォーカスしていない時の背景色(好きな値・色に変更)
-- vim.cmd 'let g:InactiveBackGround = "guibg=NONE"'

-- Neovim内でフォーカスしていないペインの背景色設定
-- vim.cmd 'execute ("hi NormalNC ".g:InactiveBackGround)'
-- vim.cmd 'execute ("hi NontextNC ".g:InactiveBackGround)'
-- vim.cmd 'execute ("hi SpecialkeyNC ".g:InactiveBackGround)'
-- vim.cmd 'execute ("hi EndOfBufferNC ".g:InactiveBackGround)'

--Neovim自体からフォーカスを外したりした際の切替設定
--(フォーカスした時の設定はcolorschemeに合わせて変更）
-- vim.cmd [[
-- augroup ChangeBackGround
-- autocmd!
-- autocmd FocusGained * hi Normal guifg=#a0a8cd guibg=#11121d
-- autocmd FocusGained * hi NonText guifg=#4a5057 guibg=#11121d
-- autocmd FocusGained * hi SpecialKey guifg=#4a5057 guibg=#11121d
-- autocmd FocusGained * hi EndOfBuffer guifg=#212234 guibg=#11121d
-- autocmd FocusLost * execute('hi Normal '.g:InactiveBackGround)
-- autocmd FocusLost * execute('hi NonText '.g:InactiveBackGround)
-- autocmd FocusLost * execute('hi SpecialKey '.g:InactiveBackGround)
-- autocmd FocusLost * execute('hi EndOfBuffer '.g:InactiveBackGround)
-- augroup end
-- ]]
-- vim.cmd 'highlight Normal ctermbg=NONE guibg=NONE'
-- vim.cmd 'highlight NonText ctermbg=NONE guibg=NONE'
-- vim.cmd 'highlight LineNr ctermbg=NONE guibg=NONE'
-- vim.cmd 'highlight Folded ctermbg=NONE guibg=NONE'
-- vim.cmd 'highlight SpecialKey ctermbg=NONE guibg=NONE'
-- vim.cmd 'highlight EndOfBuffer ctermbg=NONE guibg=NONE'
--
-- vim.cmd 'highlight Comment guifg=#43676b'

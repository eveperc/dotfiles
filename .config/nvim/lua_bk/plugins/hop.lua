local status,hop = pcall(require,'hop')
if (not status) then return end

-- you can configure Hop the way you like here; see :h hop-config
hop.setup({keys = "etovxqpdygfblzhckisuran"})
vim.cmd 'hi HopNextKey guifg=#fb4934'
vim.cmd 'hi HopNextKey1 guifg=#7fa2ac'
vim.cmd 'hi HopNextKey2 guifg=#d4879c'

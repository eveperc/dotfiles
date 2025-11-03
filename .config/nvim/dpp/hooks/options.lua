-- options.lua - Neovimの基本オプション設定
-- dpp.vimで使用するための設定ファイル

local options = {
  encoding = "utf-8",
  fileencoding = "utf-8",
  clipboard = "unnamedplus",
  whichwrap = "b,s,[,],<,>",
  backspace = "indent,eol,start",
  ambiwidth = "single",
  wildmenu = true,
  cmdheight = 1,
  laststatus = 3,
  showcmd = true,
  hlsearch = true,
  hidden = true,
  backup = true,
  backupdir = os.getenv("HOME") .. '/.vim/backup',
  winblend = 20,
  pumblend = 20,
  termguicolors = true,
  expandtab = true,
  tabstop = 2,
  shiftwidth = 2,
  smartindent = true,
  relativenumber = true,
  wrap = true,
  autoindent = true,
  nrformats = "bin,hex",
  swapfile = false,
  cursorline = true,
}

vim.opt.shortmess:append("c")

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]])

-- LSP handlers設定
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, { separator = true }
)
vim.lsp.handlers["textdocument/signaturehelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, { separator = true }
)

-- gitgutter設定
vim.cmd 'let g:gitgutter_sign_added = "+"'
vim.cmd 'let g:gitgutter_sign_modified = "^"'
vim.cmd 'let g:gitgutter_sign_removed = "-"'
vim.cmd 'highlight GitGutterAdd    guifg=#009900 ctermfg=2'
vim.cmd 'highlight GitGutterChange guifg=#bbbb00 ctermfg=3'
vim.cmd 'highlight GitGutterDelete guifg=#ff2222 ctermfg=1'
vim.cmd 'highlight GitGutterAddLine          ctermbg=2'
vim.cmd 'highlight GitGutterChangeLine       ctermbg=3'
vim.cmd 'highlight GitGutterDeleteLine       ctermbg=1'

-- fzf設定
vim.cmd "let g:fzf_preview_window = ['right:70%', 'ctrl-/']"

-- sonictemplate設定
vim.cmd "let g:sonictemplate_vim_template_dir = ['$HOME/.config/nvim/templates/']"

-- フォント設定
vim.cmd("set guifont=DroidSansMono_Nerd_Font:h11")

-- denops設定
vim.cmd "set runtimepath^=~/dps-helloworld"
vim.cmd "let g:genops#debug = 1"

-- previm設定
vim.cmd "let g:previm_open_cmd = 'open -a /Applications/Vivaldi.app'"
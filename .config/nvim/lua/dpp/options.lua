-- =====================================================================
-- Neovim Options Configuration
-- =====================================================================

local opt = vim.opt

-- General settings
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.backup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("cache") .. "/undo"

-- UI settings
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.pumheight = 10
opt.showmode = false
opt.laststatus = 3

-- Indentation
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.smartindent = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Window
opt.splitbelow = true
opt.splitright = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Performance
opt.updatetime = 300
opt.timeoutlen = 500
opt.redrawtime = 1500

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.wildmode = "longest:full,full"

-- File handling
opt.autoread = true
opt.hidden = true

-- Mouse
opt.mouse = "a"

-- Clipboard
opt.clipboard = "unnamedplus"

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
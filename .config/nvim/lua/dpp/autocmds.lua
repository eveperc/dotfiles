-- =====================================================================
-- Autocommands Configuration
-- =====================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  group = augroup("RemoveTrailingWhitespace", { clear = true }),
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Highlight yanked text
autocmd("TextYankPost", {
  group = augroup("HighlightYank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

-- Auto-resize splits when window is resized
autocmd("VimResized", {
  group = augroup("AutoResizeSplits", { clear = true }),
  pattern = "*",
  command = "wincmd =",
})

-- Set format options
autocmd("BufEnter", {
  group = augroup("FormatOptions", { clear = true }),
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Create directories when saving a file
autocmd("BufWritePre", {
  group = augroup("AutoCreateDir", { clear = true }),
  pattern = "*",
  callback = function(event)
    local file = event.match
    local dir = vim.fn.fnamemodify(file, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Return to last edit position when opening files
autocmd("BufReadPost", {
  group = augroup("ReturnToLastPosition", { clear = true }),
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Terminal settings
autocmd("TermOpen", {
  group = augroup("TerminalSettings", { clear = true }),
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
})
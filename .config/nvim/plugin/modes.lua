-- Attempt to require the 'modes' module
local status, modes = pcall(require, 'modes')
if not status then
  print("Failed to load modes module")
  return
end

-- Ensure 'modes' is a table
if type(modes) ~= "table" then
  print("Unexpected type for modes: " .. type(modes))
  return
end

-- modes.nvim setup
modes.setup({
  colors = {
    copy = "#f5c359",
    delete = "#c75c6a",
    insert = "#78ccc5",
    visual = "#9745be",
  },

  -- Set opacity for cursorline and number background
  line_opacity = 0.15,

  -- Enable cursor highlights
  set_cursor = true,

  -- Enable cursorline initially, and disable cursorline for inactive windows
  -- or ignored filetypes
  set_cursorline = true,

  -- Enable line number highlights to match cursorline
  set_number = true,

  -- Disable modes highlights in specified filetypes
  -- Please PR commonly ignored filetype
})

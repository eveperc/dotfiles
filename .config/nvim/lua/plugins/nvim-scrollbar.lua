local status, scrollbar = pcall(require, 'scrollbar')
if (not status) then return end

local colors = require("gruvbox-baby.colors").config()

scrollbar.setup({
  handle = {
    color = colors.foreground,
  },
  marks = {
    Search = { color = colors.pink },
    Error = { color = colors.error_red },
    Warn = { color = colors.bright_yellow },
    Info = { color = colors.forest_green },
    Hint = { color = colors.blue_gray },
    Misc = { color = colors.light_blue },
  }
})

local status, noice = pcall(require, 'noice')
if (not status) then return end

noice.setup({

  sections = {
    lualine_x = {
      {
        require("noice").api.statusline.mode.get,
        cond = require("noice").api.statusline.mode.has,
        color = { fg = "#ff9e64" },
      }
    },
  },
  views = {
    cmdline_popup = {
      border = {
        -- style = "none",
        -- padding = { 2, 3 },
      },
      filter_options = {},
      win_options = {
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      },
    },
  },
  health = {
    checker = false, -- Disable if you don't want health checks to run
  },
})

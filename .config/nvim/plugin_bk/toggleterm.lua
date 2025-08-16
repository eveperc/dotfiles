local status,toggleterm = pcall(require,'toggleterm')
if (not status) then return end

toggleterm.setup {
  open_mapping = [[<c-\>]],
  direction = 'float',
  auto_scroll = true, -- automatically scroll to the bottom on terminal output
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = 'curved',
    -- like `size`, width and height can be a number or function which is passed the current terminal
    winblend = 3,
  },
}

local status,terminal = pcall(require,'toggleterm.terminal')
if (not status) then return end

local Terminal = terminal.Terminal
local lazygit = Terminal:new({
  cmd = "lazygit",
  direction = "float",
  hidden = true,
})

function _lazygit_toggle()
  lazygit:toggle()
end

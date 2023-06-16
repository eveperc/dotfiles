local wezterm = require 'wezterm';

return {
  font = wezterm.font("PlemolJP35 Console NF",{ weight = 'Bold', italic = false }), -- 自分の好きなフォントいれる
  use_ime = true, -- wezは日本人じゃないのでこれがないとIME動かない
  font_size = 10.0,
  color_scheme = 'Everforest Dark (Gogh)',
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,
  scrollback_lines = 1000,
  window_background_opacity = 0.8,
  keys = {
    {
      key = 'g',
      mods = 'CTRL',
      action = wezterm.action.PaneSelect
    },
  },
  colors = {
    cursor_fg = "#000000",
  }
}

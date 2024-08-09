local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

config.color_scheme = "Catppuccin Mocha"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = '1cell',
  right = '1cell',
  top = '0.4cell',
  bottom = '1cell',
}
config.window_decorations = "RESIZE"
config.window_background_opacity = 1
-- config.enable_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
-- config.tab_bar_at_bottom = true
-- config.show_close_tab_button_in_tabs = false
config.tab_max_width = 30
-- config.win32_system_backdrop = 'Mica'
config.text_background_opacity = 0.3
config.initial_cols=100
config.initial_rows=24
-- config.font = wezterm.font('JetBrains Mono', { weight = 'Bold'})
config.font = wezterm.font('JetBrains Mono')
config.font_size = 16
config.colors = {
  background='#070b11',
  foreground='#ec275f',
}

-- Spawn a fish shell in login mode
config.default_prog = { 'D:\\scoop\\apps\\pwsh\\current\\pwsh.exe', '-Nologo' }



config.window_frame = {
  inactive_titlebar_bg = '#070b11',
  active_titlebar_bg = '#070b11',
  inactive_titlebar_fg = '#cccccc',
  active_titlebar_fg = '#979cac',
  inactive_titlebar_border_bottom = '#2b2042',
  active_titlebar_border_bottom = '#2b2042',
  button_fg = '#cccccc',
  button_bg = '#2b2042',
  button_hover_fg = '#ffffff',
  button_hover_bg = '#3b3052',
  font_size = 14.0,
}


function tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end
  return tab_info.active_pane.title
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local title = tab_title(tab)
    if tab.is_active then
      return {
        { Background = { Color = '#16191f' } },
        -- { Text = ' ' .. title .. 'pwsh' },
        { Text = '  pwsh  ' },
      }
    end
    return {
        { Background = { Color = '#070b11' } },
        -- { Text = ' ' .. title .. 'pwsh' },
        { Text = '  pwsh  ' },
      }
  end
)


return config
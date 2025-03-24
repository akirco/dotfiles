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
config.tab_bar_at_bottom = true
-- config.show_close_tab_button_in_tabs = false
config.tab_max_width = 30
config.win32_system_backdrop = 'Mica'
config.text_background_opacity = 0.3
config.initial_cols=100
config.initial_rows=24
-- config.font = wezterm.font('JetBrains Mono', { weight = 'Bold'})
config.font = wezterm.font('JetBrains Mono')
config.font_size = 14
config.colors = {
  background='#070b11',
  foreground='#ec275f',
}

-- Spawn a fish shell in login mode
config.default_prog = { 'E:\\scoop\\apps\\pwsh\\current\\pwsh.exe', '-Nologo' }



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


-- 启动监听，初始化窗口
wezterm.on("gui-startup", function(cmd)

    -- 遍历，找到对应的显示器名称
    local screen
    local screens = wezterm.gui.screens().by_name
    for name_tmp, screen_tmp in pairs(screens) do
        if name_tmp == current_screen then
            -- 此处给全局变量 current_screen 赋值了，在“update-status”事件中有用到
            current_screen = name_tmp
            screen = screen_tmp
        end
    end

    -- 如果找不到指定显示器，就取默认值 main
    if screen == nil then
        screen = wezterm.gui.screens().main
    end

    -- 初始化窗口
    -- local ratio = 0.7
    -- local width, height = screen.width * ratio, screen.height * ratio
    local width, height = 1250, 800  --指定窗口宽高，单位 px
    local tab, pane, window = wezterm.mux.spawn_window(cmd or {
        -- width = 50,  -- 这个长宽是行列数，不适合用来计算
        -- height = 30,
        position = {
            x = (screen.width - width) / 2,
            y = (screen.height - height) / 2 * 0.8,  -- 乘以 0.8 让窗口稍微偏上一些更舒适
            origin = {Named=screen.name}
        },
    })
    window:gui_window():set_inner_size(width, height)  -- 这里的长宽单位是 px
end)



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
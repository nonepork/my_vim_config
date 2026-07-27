-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Terminals

config.default_prog = { "pwsh.exe", "-NoLogo" }
config.launch_menu = {
	{
		label = "PowerShell",
		args = { "powershell.exe" },
	},
	{
		label = "Command Prompt",
		args = { "cmd.exe" },
	},
}

-- Appearances

local tokyonightmoon = wezterm.color.get_builtin_schemes()["tokyonight_moon"]
tokyonightmoon.background = "#0b0b0f"

config.color_schemes = {
	["dark_tokyonight_moon"] = tokyonightmoon,
}
config.color_scheme = "dark_tokyonight_moon"
config.font = wezterm.font("Iosevka Nerd Font")
config.font_size = 12
config.line_height = 1.1
config.cell_width = 1

-- config.enable_tab_bar = false

-- config.window_decorations = "TITLE | RESIZE"
config.window_decorations = "RESIZE"

config.default_cursor_style = "BlinkingBar"
config.animation_fps = 1
config.cursor_blink_rate = 550

config.max_fps = 144

config.term = "xterm-256color"
config.front_end = "WebGpu"

-- Tmux like settings
-- https://www.youtube.com/watch?v=V1X4WQTaxrc

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2001 }
config.keys = {
	{
		mods = "LEADER",
		key = "c",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "q",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "LEADER",
		key = "b",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		mods = "LEADER",
		key = "n",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		mods = "LEADER",
		key = "\\",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "-",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "h",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		mods = "LEADER",
		key = "j",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		mods = "LEADER",
		key = "k",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		mods = "LEADER",
		key = "l",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		mods = "LEADER",
		key = "LeftArrow",
		action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	},
	{
		mods = "LEADER",
		key = "RightArrow",
		action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	},
	{
		mods = "LEADER",
		key = "DownArrow",
		action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	},
	{
		mods = "LEADER",
		key = "UpArrow",
		action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	},
	{
		mods = "LEADER",
		key = ",",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

for i = 1, 9 do
	-- leader + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

-- Tab bar

config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.tab_and_split_indices_are_zero_based = false
config.window_frame = {
	font_size = 10,
	active_titlebar_bg = "#141620",
	inactive_titlebar_bg = "#141620",
}
config.colors = {
	tab_bar = {
		inactive_tab_edge = "#141620",
		active_tab = {
			bg_color = "#141620",
			fg_color = "#c6a0f6",
		},
		inactive_tab = {
			bg_color = "#141620",
			fg_color = "#808080",
		},
	},
}

-- Tmux status

wezterm.on("update-right-status", function(window, _)
	local SOLID_LEFT_ARROW = ""
	local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } }
	local prefix = ""

	if window:leader_is_active() then
		prefix = " " .. utf8.char(0x1f30a) -- ocean wave
		-- SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	end

	if window:active_tab():tab_id() ~= 0 then
		ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
	end -- arrow color based on if tab is first pane

	window:set_left_status(wezterm.format({
		-- { Background = { Color = "#b7bdf8" } },
		{ Text = prefix },
		ARROW_FOREGROUND,
		{ Text = SOLID_LEFT_ARROW },
	}))
end)

-- Mouse related
local act = wezterm.action
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelection("ClipboardAndPrimarySelection"),
	},
	-- Bind 'Up' event of CTRL-Click to open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
	-- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
	{
		event = { Down = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.Nop,
	},
}

-- and finally, return the configuration to wezterm
return config

-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

local act = wezterm.action

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 80
config.initial_rows = 20

-- or, changing the font size and color scheme.
config.font_size = 15
config.font = wezterm.font("Moralerspace Neon", { weight = "Regular" })
config.line_height = 1.25
config.cell_width = 0.9

config.color_scheme = "Catppuccin Mocha"

-- Hide window decorations (close, minimize, maximize buttons)
config.window_decorations = "RESIZE"

-- See https://wezterm.org/changelog.html?h=send_compo#20200718-095447-d2315640
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false

-- Window frame and tab bar
config.window_frame = {
	inactive_titlebar_bg = "transparent",
	active_titlebar_bg = "transparent",
}
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = true

-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, pane)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name
	end
	window:set_right_status(name or "")
end)

-- Keybindings
config.leader = { key = "b", mods = "CTRL" }
config.keys = {
	{
		key = "[",
		mods = "LEADER",
		action = act.ActivateCopyMode,
	},
	{
		key = "]",
		mods = "LEADER",
		action = act.QuickSelect,
	},
	{
		key = "p",
		mods = "LEADER",
		action = act.ActivateCommandPalette,
	},
	{
		key = "v",
		mods = "LEADER",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "h",
		mods = "LEADER",
		action = act.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	-- CTRL+SHIFT+Space, followed by 'r' will put us in resize-pane
	-- mode until we cancel that mode.
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},

	-- CTRL+SHIFT+Space, followed by 'a' will put us in activate-pane
	-- mode until we press some other key or until 1 second (1000ms)
	-- of time elapses
	{
		key = "a",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "activate_pane",
			timeout_milliseconds = 1000,
		}),
	},
}
config.key_tables = {
	-- Defines the keys that are active in our resize-pane mode.
	-- Since we're likely to want to make multiple adjustments,
	-- we made the activation one_shot=false. We therefore need
	-- to define a key assignment for getting out of this mode.
	-- 'resize_pane' here corresponds to the name="resize_pane" in
	-- the key assignments above.
	resize_pane = {
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },

		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },

		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },

		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},

	-- Defines the keys that are active in our activate-pane mode.
	-- 'activate_pane' here corresponds to the name="activate_pane" in
	-- the key assignments above.
	activate_pane = {
		{ key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
		{ key = "h", action = act.ActivatePaneDirection("Left") },

		{ key = "RightArrow", action = act.ActivatePaneDirection("Right") },
		{ key = "l", action = act.ActivatePaneDirection("Right") },

		{ key = "UpArrow", action = act.ActivatePaneDirection("Up") },
		{ key = "k", action = act.ActivatePaneDirection("Up") },

		{ key = "DownArrow", action = act.ActivatePaneDirection("Down") },
		{ key = "j", action = act.ActivatePaneDirection("Down") },
	},
}

-- Finally, return the configuration to wezterm:
return config

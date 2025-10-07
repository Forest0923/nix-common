local wezterm = require('wezterm')

local config = {
	font		= wezterm.font('Fira Code'),
	font_size	= 13,

	front_end	= "WebGpu",

	colors = {
		background	= "#000000",
		foreground	= "#eaeaea",
		ansi		= {'#000000', '#d54e53', '#23d18b', '#e6c547', '#3b8eea', '#c397d8', '#70c0ba', '#e5e5e5'},
		brights		= {'#666666', '#ff3334', '#0dbc79', '#e7c547', '#2472c8', '#b77ee0', '#29b8db', '#e5e5e5'},
	},

	window_padding = {
		left	= 7,
		right	= 7,
		top	= 2,
		bottom	= 2,
	},
	window_background_opacity	= 0.68,
	text_background_opacity		= 1.0,

	enable_tab_bar			= true,
	hide_tab_bar_if_only_one_tab	= true,

	exit_behavior			= "Close",
	audible_bell= "Disabled",
	keys = {
		{ key = ' ', mods = 'SHIFT', action = wezterm.action.QuickSelect },
	},

	quick_select_patterns = {
		"((?:[A-Za-z0-9]+[\\.\\-_/])+[A-Za-z0-9\\.]+)",
	},
	warn_about_missing_glyphs = false,
}

if wezterm.target_triple == "x86_64-unknown-linux-gnu" then
	-- for Linux
	config.window_decorations	= "NONE"
elseif wezterm.target_triple == "aarch64-apple-darwin" then
	-- for macOS
	config.window_decorations	= "TITLE | RESIZE"
end

return config

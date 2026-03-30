local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local brew = sbar.add("item", "widgets.brew", {
	position = "left",
	icon = {
		string = icons.brew,
		color = colors.tn_yellow,
		font = { size = 16 },
		padding_left = 8,
	},
	label = {
		string = "—",
		color = colors.tn_yellow,
		font = { family = settings.font.numbers },
	},
	update_freq = 1800,
	padding_right = 5,
	padding_left = 0,
})

sbar.add("bracket", "widgets.brew.bracket", { brew.name }, {
	background = { color = colors.tn_black3, border_color = colors.tn_yellow },
})

brew:subscribe({ "routine", "forced" }, function()
	sbar.exec("brew outdated 2>/dev/null | wc -l | tr -d ' '", function(result)
		local count = tonumber(result) or 0
		local color = count > 0 and colors.tn_yellow or colors.grey
		brew:set({
			icon = { color = color },
			label = { string = tostring(count), color = color },
		})
		sbar.set("widgets.brew.bracket", {
			background = { border_color = color },
		})
	end)
end)

brew:subscribe("mouse.clicked", function()
	sbar.exec("open -a 'Terminal' && osascript -e 'tell application \"Terminal\" to do script \"brew upgrade\"'")
end)

sbar.add("item", { position = "left", width = 6 })

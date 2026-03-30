local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local slack = sbar.add("item", "widgets.slack", {
	position = "left",
	icon = {
		string = icons.slack,
		color = colors.grey,
		font = { size = 16 },
		padding_left = 8,
	},
	label = {
		string = "—",
		color = colors.grey,
		font = { family = settings.font.numbers },
	},
	update_freq = 5,
	padding_right = 5,
	padding_left = 0,
})

sbar.add("bracket", "widgets.slack.bracket", { slack.name }, {
	background = { color = colors.tn_black3, border_color = colors.grey },
})

slack:subscribe({ "routine", "forced" }, function()
	sbar.exec(
		"lsappinfo info -only StatusLabel 'Slack' 2>/dev/null | grep -o '\"label\"=\"[^\"]*\"' | cut -d'\"' -f4",
		function(result)
			local label = result:match("[^\r\n]+") or ""
			local count = tonumber(label) or 0
			local has_notif = label ~= "" and label ~= "0"
			local color = has_notif and colors.tn_red or colors.grey
			slack:set({
				icon = { color = color },
				label = {
					string = has_notif and tostring(count > 0 and count or "!") or "0",
					color = color,
				},
			})
			sbar.set("widgets.slack.bracket", {
				background = { border_color = color },
			})
		end
	)
end)

slack:subscribe("mouse.clicked", function()
	sbar.exec("open -a 'Slack'")
end)

sbar.add("item", { position = "left", width = 6 })

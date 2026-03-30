local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local disk = sbar.add("item", "widgets.disk", {
	position = "right",
	icon = {
		string = icons.disk,
		color = colors.tn_cyan,
		font = { size = 16 },
		padding_left = 8,
	},
	label = {
		string = "??%",
		color = colors.tn_cyan,
		font = { family = settings.font.numbers },
	},
	update_freq = 60,
	padding_right = 5,
	padding_left = 0,
})

local bracket = sbar.add("bracket", "widgets.disk.bracket", { disk.name }, {
	background = { color = colors.tn_black3, border_color = colors.tn_cyan },
})

disk:subscribe({ "routine", "forced" }, function()
	sbar.exec("df -h / | tail -1 | awk '{print $5}'", function(result)
		local usage = result:match("(%d+)%%")
		if usage then
			local pct = tonumber(usage)
			local color = colors.tn_cyan
			if pct > 80 then
				color = colors.tn_red
			elseif pct > 60 then
				color = colors.tn_orange
			end
			disk:set({
				icon = { color = color },
				label = { string = usage .. "%", color = color },
			})
			bracket:set({ background = { border_color = color } })
		end
	end)
end)

disk:subscribe("mouse.clicked", function()
	sbar.exec("open -a 'System Information'")
end)

sbar.add("item", { position = "right", width = 6 })

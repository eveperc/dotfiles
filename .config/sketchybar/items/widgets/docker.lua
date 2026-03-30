local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local docker = sbar.add("item", "widgets.docker", {
	position = "left",
	icon = {
		string = icons.docker,
		color = colors.tn_skyblue,
		font = { size = 16 },
		padding_left = 8,
	},
	label = {
		string = "—",
		color = colors.tn_skyblue,
		font = { family = settings.font.numbers },
	},
	update_freq = 10,
	padding_right = 5,
	padding_left = 0,
})

sbar.add("bracket", "widgets.docker.bracket", { docker.name }, {
	background = { color = colors.tn_black3, border_color = colors.tn_skyblue },
})

docker:subscribe({ "routine", "forced" }, function()
	sbar.exec("docker ps -q 2>/dev/null | wc -l | tr -d ' '", function(result)
		local count = tonumber(result) or -1
		if count < 0 then
			docker:set({
				icon = { color = colors.grey },
				label = { string = "Off", color = colors.grey },
			})
			sbar.set("widgets.docker.bracket", {
				background = { border_color = colors.grey },
			})
		else
			local color = count > 0 and colors.tn_skyblue or colors.grey
			docker:set({
				icon = { color = color },
				label = { string = tostring(count), color = color },
			})
			sbar.set("widgets.docker.bracket", {
				background = { border_color = color },
			})
		end
	end)
end)

docker:subscribe("mouse.clicked", function()
	sbar.exec("open -a 'Rancher Desktop'")
end)

sbar.add("item", { position = "left", width = 6 })

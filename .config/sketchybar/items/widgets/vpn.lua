local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local vpn = sbar.add("item", "widgets.vpn", {
	position = "left",
	icon = {
		string = icons.vpn,
		color = colors.grey,
		font = { size = 16 },
		padding_left = 8,
	},
	label = {
		string = "Off",
		color = colors.grey,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Semibold"],
			size = 11,
		},
	},
	update_freq = 5,
	padding_right = 5,
	padding_left = 0,
})

sbar.add("bracket", "widgets.vpn.bracket", { vpn.name }, {
	background = { color = colors.tn_black3, border_color = colors.grey },
})

vpn:subscribe({ "routine", "forced" }, function()
	sbar.exec(
		"pgrep -f acvc-openvpn >/dev/null 2>&1 && echo 1 || scutil --nc list 2>/dev/null | grep -c Connected",
		function(result)
			local connected = tonumber(result) or 0
			local is_on = connected > 0
			local color = is_on and colors.tn_green or colors.grey
			vpn:set({
				icon = { color = color },
				label = {
					string = is_on and "VPN" or "Off",
					color = color,
				},
			})
			sbar.set("widgets.vpn.bracket", {
				background = { border_color = color },
			})
		end
	)
end)

vpn:subscribe("mouse.clicked", function()
	sbar.exec("open '/Applications/AWS VPN Client/AWS VPN Client.app'")
end)

sbar.add("item", { position = "left", width = 6 })

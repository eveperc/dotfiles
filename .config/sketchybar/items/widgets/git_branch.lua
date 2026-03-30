local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local git_branch = sbar.add("item", "widgets.git_branch", {
	position = "right",
	icon = {
		string = icons.git_branch,
		color = colors.tn_magenta,
		font = { size = 16 },
		padding_left = 8,
	},
	label = {
		string = "—",
		color = colors.tn_magenta,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Semibold"],
			size = 11,
		},
		max_chars = 20,
	},
	update_freq = 5,
	padding_right = 5,
	padding_left = 0,
})

sbar.add("bracket", "widgets.git_branch.bracket", { git_branch.name }, {
	background = { color = colors.tn_black3, border_color = colors.tn_magenta },
})

git_branch:subscribe({ "routine", "forced", "front_app_switched" }, function()
	sbar.exec(
		"lsappinfo info -only pid $(lsappinfo front) 2>/dev/null | grep -o '\"pid\"=[0-9]*' | cut -d= -f2",
		function(pid_str)
			local pid = pid_str:match("%d+")
			if not pid then
				git_branch:set({ label = { string = "—" } })
				return
			end
			sbar.exec(
				"lsof -p " .. pid .. " 2>/dev/null | awk '$4==\"cwd\" {print $NF}'",
				function(cwd)
					cwd = cwd:match("[^\r\n]+") or ""
					if cwd == "" then
						git_branch:set({ label = { string = "—" } })
						return
					end
					sbar.exec(
						"git -C '" .. cwd .. "' rev-parse --abbrev-ref HEAD 2>/dev/null",
						function(branch)
							branch = branch:match("[^\r\n]+") or ""
							if branch == "" then
								git_branch:set({ label = { string = "—" } })
							else
								git_branch:set({ label = { string = branch } })
							end
						end
					)
				end
			)
		end
	)
end)

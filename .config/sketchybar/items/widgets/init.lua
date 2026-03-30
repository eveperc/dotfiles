-- right side
require("items.widgets.disk")
require("items.widgets.battery")
require("items.widgets.volume")
require("items.widgets.wifi")
require("items.widgets.memory")
require("items.widgets.cpu")
-- require("items.widgets.git_branch")

-- left side
sbar.add("item", { position = "left", width = 8 })
require("items.widgets.slack")
require("items.widgets.vpn")
require("items.widgets.brew")
require("items.widgets.docker")

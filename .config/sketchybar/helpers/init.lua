-- Add the sketchybar module to the package cpath (must be set before require)
package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"

-- Build helper binaries
local config_dir = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
os.execute("(cd " .. config_dir .. "/sketchybar/helpers && make)")

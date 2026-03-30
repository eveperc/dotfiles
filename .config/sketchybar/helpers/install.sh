# Packages
brew install lua
brew install switchaudio-osx
brew install nowplaying-cli

brew tap FelixKratz/formulae
brew install sketchybar

# Fonts
brew install --cask sf-symbols
brew install --cask homebrew/cask-fonts/font-sf-mono
brew install --cask homebrew/cask-fonts/font-sf-pro

curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.5/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf

# sketchybar-app-font-bg: build and install font + icon_map.lua
(git clone https://github.com/SoichiroYamane/sketchybar-app-font-bg.git /tmp/sketchybar-app-font-bg && cd /tmp/sketchybar-app-font-bg/ && pnpm install && pnpm run build:install && rm -rf /tmp/sketchybar-app-font-bg/)

# SbarLua
(git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)

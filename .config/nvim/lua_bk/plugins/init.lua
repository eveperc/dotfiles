--[[
Neovimの設定エントリーポイント / Neovim Configuration Entry Point

このファイルは以下のモジュールを読み込みます：
This file loads the following modules:

1. base      - 基本設定（エンコーディング、バックアップなど）
               Basic settings (encoding, backup, etc.)
2. plugins   - プラグイン管理とその設定
               Plugin management and configuration
3. autocmds  - 自動コマンドの設定
               Autocommand settings
4. options   - Neovimのオプション設定
               Neovim option settings
5. keymaps   - キーマッピングの設定
               Key mapping configuration
6. colorscheme - カラースキームの設定
                 Color scheme settings
--]]

-- 基本設定の読み込み / Load basic settings
require("base")

-- プラグインマネージャーと各プラグインの設定 / Plugin manager and plugin configurations
require("plugins")

-- 自動コマンドの設定 / Autocommand settings
require("autocmds")

-- Neovimのオプション設定 / Neovim option settings
require("options")

-- キーマッピングの設定 / Key mapping configuration
require("keymaps")

-- カラースキームの設定 / Color scheme settings
require("colorscheme")

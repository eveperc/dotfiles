# dpp.vim 使用ガイド

## セットアップ完了

dpp.vimの設定が完了しました。以下の構成で動作します：

```
~/.config/nvim/
├── init.lua          # メインエントリーポイント（dpp.vim設定）
├── config.ts         # dpp.vim用TypeScript設定
├── dpp/
│   ├── plugins.toml  # 基本プラグイン（遅延読み込みなし）
│   └── lazy.toml     # 遅延読み込みプラグイン
├── backup_lazy_to_dpp/  # 旧lazy.nvim設定のバックアップ
└── lua_bk/           # Lua設定のバックアップ
```

## 初回起動時の手順

1. **Neovimを起動**
```bash
nvim
```

2. **プラグインの状態を作成**（初回のみ）
```vim
:DppMakeState
```

3. **プラグインをインストール**
```vim
:DppInstall
```

4. **Neovimを再起動**
```vim
:q
nvim
```

## コマンド一覧

| コマンド | 説明 |
|---------|------|
| `:DppInstall` | プラグインをインストール |
| `:DppUpdate` | プラグインを更新 |
| `:DppUpdate [plugin-name]` | 特定のプラグインを更新 |
| `:DppMakeState` | 状態ファイルを再生成 |

## トラブルシューティング

### Denoが必要な場合
```bash
# macOS
brew install deno

# Linux
curl -fsSL https://deno.land/x/install/install.sh | sh
```

### プラグインが読み込まれない場合
1. 状態ファイルを再生成
```vim
:DppMakeState
```

2. Neovimを再起動して再度インストール
```vim
:DppInstall
```

### denops.vimの確認
```vim
:checkhealth denops
```

## プラグインの追加方法

### 1. 通常のプラグイン（`dpp/plugins.toml`に追加）
```toml
[[plugins]]
repo = 'author/plugin-name'
```

### 2. 遅延読み込みプラグイン（`dpp/lazy.toml`に追加）
```toml
[[plugins]]
repo = 'author/plugin-name'
on_cmd = ['CommandName']  # コマンド実行時に読み込み
on_event = ['BufRead']    # イベント発生時に読み込み
hook_source = '''
lua << EOF
-- Lua設定
require('plugin-name').setup()
EOF
'''
```

### 3. 変更を反映
```vim
:DppMakeState
:DppInstall
```

## 現在インストールされているプラグイン

### 基本プラグイン
- dpp.vim関連（dpp.vim, denops.vim, 拡張機能）
- nvim-treesitter（構文ハイライト）
- plenary.nvim（依存ライブラリ）
- nvim-web-devicons（アイコン）

### 遅延読み込みプラグイン
- tokyonight.nvim（カラースキーム）
- lualine.nvim（ステータスライン）
- gitsigns.nvim（Git差分表示）
- Comment.nvim（コメント機能）
- nvim-autopairs（自動括弧）
- nvim-tree.lua（ファイルエクスプローラー）
- fzf-lua（ファジーファインダー）

## 注意事項

- 初回起動時はdenops.vimの初期化に時間がかかる場合があります
- プラグインの設定を変更した後は必ず`:DppMakeState`を実行してください
- 基本設定（keymaps, options等）はバックアップディレクトリから自動的に読み込まれます
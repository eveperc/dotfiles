# Neovim Configuration with dpp.vim

## 概要

このNeovim設定は`dpp.vim`（Dark Powered Plugin manager）を使用したモジュール化された構成です。`lazy.nvim`から`dpp.vim`に移行し、TypeScriptベースの設定管理とTOMLファイルによるプラグイン定義を採用しています。

## ディレクトリ構造

```
~/.config/nvim/
├── init.lua              # エントリーポイント
├── config.ts             # dpp.vim設定ファイル（TypeScript）
├── dpp/                  # プラグイン設定ディレクトリ
│   ├── base.toml        # 基本設定読み込み
│   ├── core.toml        # コアプラグイン
│   ├── lazy.toml        # 遅延読み込みプラグイン
│   ├── lsp.toml         # LSP関連
│   ├── completion.toml  # 補完関連
│   ├── ui.toml          # UI拡張
│   ├── editing.toml     # 編集機能拡張
│   ├── git.toml         # Git統合
│   ├── tools.toml       # 開発ツール
│   └── hooks/           # Lua設定ファイル
│       ├── options.lua   # Neovimオプション
│       ├── keymaps.lua   # キーマッピング
│       ├── autocmds.lua  # 自動コマンド
│       └── lsp.lua       # LSP設定
└── plugin/              # 自動読み込みスクリプト

```

## lazy.tomlの役割

`lazy.toml`は**遅延読み込み（lazy loading）プラグイン**を定義するファイルです。起動時に必須ではないプラグインを、必要なタイミングで読み込むことで起動速度を最適化します。

### 主な遅延読み込みプラグイン
- **Colorscheme**: `everforest-nvim` - VimEnterイベントで読み込み
- **UI Components**: `lualine.nvim` - ステータスライン
- **Git Integration**: `gitsigns.nvim` - バッファ読み込み時
- **Editing Helpers**: `Comment.nvim`, `nvim-autopairs` - 編集時に自動読み込み
- **File Management**: `nvim-tree.lua` - コマンド実行時
- **Fuzzy Finder**: `fzf-lua` - コマンド実行時

## 設定システムの仕組み

### 1. 起動プロセス

1. **init.lua**: 
   - dpp.vimとdenops.vimをセットアップ
   - 基本設定（options, keymaps, autocmds）を読み込み
   - dpp状態をロードまたは構築

2. **config.ts**:
   - TOMLファイルの読み込み順序を定義
   - プラグインの依存関係を管理
   - lazy/eager loading の制御

### 2. プラグイン管理

**dpp.vim**は以下の特徴を持つプラグインマネージャーです：
- TypeScriptによる設定記述
- TOMLファイルによるプラグイン定義
- 遅延読み込みのサポート
- 状態キャッシュによる高速起動

### 3. TOMLファイルの分類

| ファイル | 役割 | lazy |
|---------|------|------|
| base.toml | 基本設定フック | false |
| core.toml | 必須プラグイン | false |
| lazy.toml | 遅延プラグイン | true |
| lsp.toml | 言語サーバー | true |
| completion.toml | 自動補完 | true |
| ui.toml | UI拡張 | true |
| editing.toml | 編集機能 | true |
| git.toml | Git統合 | true |
| tools.toml | 開発ツール | true |

## 主要機能

### LSP（Language Server Protocol）
- `nvim-lspconfig`: 言語サーバー設定
- `lspsaga.nvim`: LSP UI拡張
- `nvim-navbuddy`: コードナビゲーション
- 対応言語: TypeScript, JavaScript, Python, Lua, Rust等

### 補完システム
- `nvim-cmp`: 補完エンジン
- `cmp-nvim-lsp`: LSP補完
- `cmp-buffer`: バッファ補完
- `cmp-path`: パス補完
- `copilot.vim`: GitHub Copilot

### UI拡張
- `lualine.nvim`: ステータスライン
- `bufferline.nvim`: タブライン
- `noice.nvim`: コマンドラインUI
- `nvim-notify`: 通知システム
- `everforest`: カラースキーム

### 編集支援
- `nvim-treesitter`: 構文解析
- `Comment.nvim`: コメントトグル
- `nvim-autopairs`: 括弧自動補完
- `hop.nvim`: カーソル移動
- `vim-surround`: 囲み文字操作

### Git統合
- `gitsigns.nvim`: Git差分表示
- `fugitive.vim`: Gitコマンド統合
- `diffview.nvim`: 差分ビューア

### ファイル管理
- `nvim-tree.lua`: ファイルエクスプローラー
- `telescope.nvim`: ファジーファインダー
- `fzf-lua`: 高速ファジー検索

## コマンド

### dpp.vim管理コマンド
- `:DppInstall` - プラグインをインストール
- `:DppUpdate [plugin-name]` - プラグインを更新
- `:DppMakeState` - dpp状態を再構築
- `:DppStatus` - dpp.vimの状態を表示

### よく使うキーマップ
- `<leader>e` - ファイルエクスプローラー
- `<leader>ff` - ファイル検索
- `<leader>fg` - テキスト検索
- `<leader>fb` - バッファ一覧
- `gcc` - 行コメントトグル
- `gbc` - ブロックコメントトグル

## セットアップ

### 必要要件
- Neovim >= 0.9.0
- Deno (dpp.vim用)
- Git
- Node.js (言語サーバー用)

### インストール手順

1. 設定ファイルをクローン
```bash
git clone <repository> ~/.config/nvim
```

2. Neovimを起動（自動でdpp.vimがセットアップされる）
```bash
nvim
```

3. プラグインをインストール
```vim
:DppMakeState
:DppInstall
```

## カスタマイズ

### プラグインの追加
該当するTOMLファイルに追加：
```toml
[[plugins]]
repo = 'username/plugin-name'
on_event = ['BufRead']  # 遅延読み込み条件
hook_source = '''
lua << EOF
require('plugin-name').setup({
  -- 設定
})
EOF
'''
```

### 設定の変更
- オプション: `dpp/hooks/options.lua`
- キーマップ: `dpp/hooks/keymaps.lua`
- 自動コマンド: `dpp/hooks/autocmds.lua`

## トラブルシューティング

### dpp状態の再構築
```vim
:DppMakeState
```

### プラグインの再インストール
```vim
:DppUpdate
```

### デバッグ情報の確認
```vim
:DppStatus
```

## ライセンス

MITライセンス
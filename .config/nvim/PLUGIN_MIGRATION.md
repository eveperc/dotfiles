# lazy.nvim → dpp.vim プラグイン移行完了

## 📦 移行したプラグイン

### カテゴリ別TOMLファイル構成

1. **core.toml** - 基本プラグイン（常に読み込み）
   - dpp.vim本体と拡張
   - plenary.nvim, nui.nvim
   - アイコン関連

2. **lsp.toml** - LSPと診断
   - nvim-lspconfig
   - lspsaga.nvim
   - mason.nvim
   - ALE

3. **completion.toml** - 補完とスニペット
   - nvim-cmp と関連ソース
   - LuaSnip
   - Copilot

4. **ui.toml** - UI/ビジュアル
   - lualine.nvim
   - bufferline.nvim
   - noice.nvim
   - カラースキーム各種

5. **git.toml** - Git統合
   - vim-fugitive
   - gitsigns.nvim
   - git-blame.nvim

6. **editor.toml** - エディタ拡張
   - nvim-treesitter
   - Comment.nvim
   - nvim-autopairs
   - hop.nvim
   - telescope.nvim

7. **tools.toml** - 開発ツール
   - toggleterm.nvim
   - nvim-dap
   - trouble.nvim

## 🚀 使い方

### 1. 状態を更新
```vim
:DppMakeState
```

### 2. プラグインをインストール
```vim
:DppInstall
```

### 3. Neovimを再起動
```vim
:q
nvim
```

## ⚙️ 設定ファイル

プラグイン固有の設定は以下に配置：

- `dpp/hooks/lsp.lua` - LSP設定（mason.lua相当）
- `dpp/hooks/completion.lua` - 補完設定（cmp.lua相当）

その他の設定は各TOMLファイルの`hook_source`に記載。

## 📝 注意事項

### 遅延読み込み
- `on_event` - イベント発生時に読み込み
- `on_cmd` - コマンド実行時に読み込み
- `on_ft` - ファイルタイプ検出時に読み込み
- `on_source` - 他のプラグインが読み込まれた時

### トラブルシューティング

#### プラグインが読み込まれない場合
```vim
" 状態を再生成
:DppMakeState

" デバッグ情報を確認
:echo dpp#debug#plugins()
```

#### 特定のプラグインを無効化
TOMLファイルから該当行を削除またはコメントアウト：
```toml
# [[plugins]]
# repo = 'plugin-to-disable'
```

#### 依存関係エラー
`depends`フィールドで依存関係を明示：
```toml
[[plugins]]
repo = 'dependent-plugin'
depends = ['required-plugin']
```

## 🔄 今後の作業

1. **プラグイン設定の最適化**
   - 各プラグインの`hook_source`を調整
   - 遅延読み込みの最適化

2. **カスタム設定の移行**
   - plugin/ディレクトリの設定をhooks/に移行
   - lua/ディレクトリの設定を整理

3. **パフォーマンス調整**
   - 起動時間の測定
   - 不要なプラグインの削除

## 📊 移行統計

- **総プラグイン数**: 約90個
- **カテゴリ数**: 7個
- **遅延読み込み**: 約80%のプラグイン

## ✅ 動作確認チェックリスト

- [ ] LSP動作確認（`:LspInfo`）
- [ ] 補完動作確認（InsertモードでCtrl+Space）
- [ ] Git統合確認（`:Git status`）
- [ ] Treesitter確認（`:TSInstallInfo`）
- [ ] ファジーファインダー（`:FzfLua files`）
- [ ] ターミナル（`:ToggleTerm`）
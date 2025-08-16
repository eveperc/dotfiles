# マッピング競合の修正

## 問題
`s`キーが複数のプラグインで競合していた：
- vim-sandwich
- substitute.nvim

## 解決策

### 1. 遅延読み込み条件を変更
- `on_map`から`on_event`や`on_cmd`に変更
- プラグインの読み込みタイミングを調整

### 2. デフォルトマッピングを無効化
```lua
vim.g.sandwich_no_default_key_mappings = 1
```

### 3. カスタムマッピングを設定

#### vim-sandwich（サラウンド操作）
- `sa` - 追加 (add)
- `sd` - 削除 (delete)
- `sr` - 置換 (replace)

#### substitute.nvim（置換操作）
- `ss` - オペレータ
- `sh` - 行全体
- `S` - 行末まで

#### hop.nvim（カーソル移動）
- `<leader>hw` - 単語へジャンプ
- `<leader>hl` - 行へジャンプ
- `<leader>hc` - 文字へジャンプ

## 適用方法

1. 状態を更新
```vim
:DppMakeState
```

2. Neovimを再起動
```vim
:q
nvim
```

3. 必要に応じてキーマップファイルを読み込み
```vim
:source ~/.config/nvim/dpp/hooks/keymaps_fix.lua
```

## 確認方法

```vim
" マッピングの確認
:nmap s
:xmap s

" 競合がないことを確認
:verbose map s
```
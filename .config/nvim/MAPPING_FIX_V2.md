# マッピングエラー修正 v2

## 修正内容

### 1. on_map設定を完全に削除
以下のプラグインの`on_map`を変更：

- **nvim-alt-substitute**
  - `on_map = {n = '<leader>s'}` → `on_cmd` + `on_event`

- **vim-edgemotion**
  - `on_map = {n = '<Plug>'}` → `on_cmd` + `on_event`

### 2. 重複プラグインを削除
- `phaazon/hop.nvim` をコメントアウト（`smoka7/hop.nvim`と重複）

### 3. マッピング競合の回避
すべてのプラグインを以下の方法で読み込み：
- `on_event` - BufRead時に読み込み
- `on_cmd` - コマンド実行時に読み込み
- デフォルトキーマップを無効化

## 適用手順

1. **状態をクリア**
```bash
rm -rf ~/.cache/dpp/state_nvim.vim
rm -rf ~/.cache/dpp/.cache
```

2. **Neovimを起動して再構築**
```vim
:DppMakeState
:DppInstall
```

3. **再起動**
```vim
:q
nvim
```

## 確認方法

```vim
" エラーがないことを確認
:messages

" マッピングを確認
:map s
:verbose map s
```

## カスタムキーマップ

必要に応じて以下のファイルでキーマップを設定：
- `~/.config/nvim/dpp/hooks/keymaps_fix.lua`
- または既存の `keymaps.lua`

## トラブルシューティング

それでもエラーが出る場合：

1. **すべてのキャッシュをクリア**
```bash
rm -rf ~/.cache/dpp
rm -rf ~/.cache/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
```

2. **最小構成でテスト**
一時的に`editor.toml`を無効化して確認：
```bash
mv dpp/editor.toml dpp/editor.toml.bak
```

3. **デバッグ情報を確認**
```vim
:echo dpp#debug#plugins()
:checkhealth
```
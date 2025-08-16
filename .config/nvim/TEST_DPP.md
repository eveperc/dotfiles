# dpp.vim テスト手順

## 問題
「dpp.vim is not initialized yet」エラーが発生する

## 解決策

### 方法1: シンプルな初期化スクリプトを使用

```bash
# バックアップを作成
cp init.lua init.lua.complex

# シンプル版を使用
cp init_simple.lua init.lua

# Neovimを起動
nvim
```

起動後、以下を確認：
1. 「Starting Neovim with dpp.vim...」と表示される
2. 少し待つ（denops.vimの初期化）
3. `:DppInstall`を実行

### 方法2: 手動で初期化を確認

```vim
" Neovim内で実行
:echo exists('*dpp#begin')
" 1が返れば初期化成功

" 0の場合は以下を実行
:echo &runtimepath
" dpp.vimのパスが含まれているか確認

" denopsの状態を確認
:checkhealth denops
```

### 方法3: デバッグモードで起動

```bash
# デバッグ情報を有効化
nvim -V10debug.log

# ログを確認
grep -i dpp debug.log
grep -i denops debug.log
```

## トラブルシューティング

### denops.vimが起動しない場合

1. Denoがインストールされているか確認
```bash
deno --version
```

2. denopsのデバッグを有効化
```vim
:let g:denops#debug = 1
:let g:denops#trace = 1
```

3. denopsサーバーを手動起動
```vim
:call denops#server#start()
```

### dpp.vimの関数が見つからない場合

1. runtimepathを確認
```vim
:echo &runtimepath
```

2. 手動でソース
```vim
:source ~/.cache/dpp/repos/github.com/Shougo/dpp.vim/plugin/dpp.vim
```

3. 関数の存在確認
```vim
:echo exists('*dpp#begin')
:echo exists('*dpp#load_state')
:echo exists('*dpp#min#load_state')
```

## 期待される初期化フロー

1. **起動時**
   - dpp.vim/denops.vimをruntimepathに追加
   - 拡張機能をruntimepathに追加

2. **VimEnter後**
   - dpp関数の存在確認
   - 存在する場合: dpp#begin → load_toml → dpp#end
   - 存在しない場合: DenopsReadyイベントを待つ

3. **DenopsReady後**
   - dpp.vimの初期化を再試行
   - make_stateまたは手動初期化

## 推奨される次のステップ

1. `init_simple.lua`を試す
2. それでも動かない場合は、denopsの問題を調査
3. 最終手段: dein.vimやvim-plugへの移行を検討
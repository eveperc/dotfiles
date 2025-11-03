local status, vim_vsnip = pcall(require, 'vsnip')
if (not status) then return end

vim_vsnip.setup({
  -- vim-vsnip の設定オプション
  snippets = {
    -- スニペットのディレクトリを指定
    dirs = {
      vim.fn.expand('~/.config/nvim/snippets'),
      vim.fn.expand('$PWD/.vscode') -- この行を追加または修正
    }
  },
  -- ファイルタイプごとのスニペット設定
  filetypes = {
    vue = { 'vue' },
    javascript = { 'javascript' },
    -- 他の必要なファイルタイプも同様に設定
  },
  -- その他の設定オプションをここに追加
})

-- キーマッピングの設定（オプション）
vim.cmd [[
  " Expand
  imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
  smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

  " Jump forward or backward
  imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
  smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
]]

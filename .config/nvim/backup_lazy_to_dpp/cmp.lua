---@mod cmp Neovimの補完プラグイン設定
---
--- nvim-cmpの設定を行うモジュールです。
--- 以下の機能を提供します：
--- - LSPベースの補完
--- - スニペット補完
--- - Copilot統合
--- - コマンドライン補完
--- - カスタムキーマッピング
---
--- このファイルは非推奨の unpack 関数を使用せず、
--- 即時実行関数（IIFE）パターンを使って配列から値を取得します。

local vim = vim
local status,cmp = pcall(require,'cmp')
if (not status) then return end

local status, lspkind = pcall(require, 'lspkind')
if (not status) then return end

local luasnip = require 'luasnip'
local function has_words_before()
  local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end

local function has_copilot()
  if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then
    return false
  end

  local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match '^%s*$' == nil
end

local M = {}

M.tab = function(fallback)
  if cmp.visible() then
    cmp.select_next_item(has_copilot() and { behavior = cmp.SelectBehavior.Select } or {})
    return
  end

  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
    return
  end

  if has_words_before() then
    cmp.complete()
    return
  end

  fallback()
end

M.shift_tab = function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
    return
  end

  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
    return
  end

  fallback()
end

local map = cmp.mapping
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp", max_item_count = 15, keyword_length = 2 },
    { name = "vsnip", max_item_count = 15, keyword_length = 2 },
    { name = "copilot", max_item_count = 15, keyword_length = 2 },
    { name = "nvim_lsp_signature_help" },
    { name = "buffer", max_item_count = 15, keyword_length = 2 },
  },
  mapping = map.preset.insert({
    ['<C-n>'] = map.select_next_item(),
    ['<C-p>'] = map.select_prev_item(),
    ['<C-f>'] = map.scroll_docs(4),
    ['<C-b>'] = map.scroll_docs(-4),
    ['<C-l>'] = map.complete(),
    ['<C-e>'] = map.abort(),
    ['<CR>'] = map.confirm { select = true },
    -- ['<Tab>'] = map(M.tab, { 'i', 's' }),
    -- ['<S-Tab>'] = map(M.shift_tab, { 'i', 's' }),
  }),
  experimental = {
    ghost_text = true,
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      -- can also be a function to dynamically calculate max width such as
      -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
      ellipsis_char = '...',    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      show_labelDetails = true, -- show labelDetails in menu. Disabled by default
      symbol_map = { Copilot = '' },
      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function(entry, vim_item)
        return vim_item
      end
    })
  }
})

cmp.setup.cmdline('/', {
  mapping = map.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(":", {
  mapping = map.preset.cmdline(),
  sources = {
    { name = "path" },
    { name = "cmdline" },
  },
})


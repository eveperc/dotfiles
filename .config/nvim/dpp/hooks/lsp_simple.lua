-- Simple LSP Setup - 直接サーバーをセットアップ
local M = {}

M.setup = function()
  local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
  if not lspconfig_ok then
    -- vim.notify("lspconfig not available", vim.log.levels.ERROR)
    return
  end
  
  -- capabilitiesの設定
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if cmp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
  
  -- on_attach関数
  local on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }
    
    -- キーマッピング設定
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'ge', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[e', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']e', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)
  end
  
  -- lua_lsのセットアップ（存在確認付き）
  if lspconfig.lua_ls then
    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' }
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        }
      }
    })
    -- vim.notify("lua_ls setup completed", vim.log.levels.INFO)
  end
  
  -- ts_lsのセットアップ
  if lspconfig.ts_ls then
    lspconfig.ts_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
    -- vim.notify("ts_ls setup completed", vim.log.levels.INFO)
  end
  
  -- rust_analyzerのセットアップ
  if lspconfig.rust_analyzer then
    lspconfig.rust_analyzer.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            loadOutDirsFromCheck = true
          },
          procMacro = {
            enable = true
          },
        }
      }
    })
    -- vim.notify("rust_analyzer setup completed", vim.log.levels.INFO)
  end

  -- Vue LSP設定
  local mason_path = vim.fn.stdpath("data") .. "/mason"
  local vue_ls_path = mason_path .. "/packages/vue-language-server/node_modules/@vue/language-server/bin/vue-language-server.js"
  local vue_plugin_path = mason_path .. "/packages/vue-language-server/node_modules/@vue/language-server"

  -- volarのセットアップ
  if lspconfig.volar then
    lspconfig.volar.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { "node", vue_ls_path, "--stdio" },
      filetypes = { "vue" },
      root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
      init_options = {
        vue = {
          hybridMode = false,
        },
      },
    })
    vim.notify("volar setup completed", vim.log.levels.INFO)
  end

  -- ts_lsにVue TypeScriptプラグインを追加
  if lspconfig.ts_ls then
    lspconfig.ts_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      init_options = {
        plugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_plugin_path,
            languages = { "vue" },
          },
        },
      },
    })
    vim.notify("ts_ls with Vue plugin setup completed", vim.log.levels.INFO)
  end
end

return M
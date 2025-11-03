-- ✅ Clean LSP Configuration for dpp.vim
-- Vue LSP問題の最終解決版
-- Mason setupは lsp.toml で実行済み

local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

-- 共通capabilities
local capabilities = (function()
  local cap = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp = pcall(require, "cmp_nvim_lsp")
  return ok and cmp.default_capabilities(cap) or cap
end)()

-- 共通on_attach
local function on_attach(client, bufnr)
  vim.notify("LSP attached: " .. client.name .. " to buffer " .. bufnr, vim.log.levels.INFO)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- キーマッピング設定
  vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>")

  vim.keymap.set('n', 'gr', '<cmd>Lspsaga finder<CR>')
  vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
  vim.keymap.set("n", "ga", "<cmd>Lspsaga code_action<CR>")
  vim.keymap.set("n", "gn", "<cmd>Lspsaga rename<CR>")
  vim.keymap.set("n", "ge", "<cmd>Lspsaga show_line_diagnostics<CR>")
  vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>")
  vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
end

-- ✅ tsdk自動検出（project > Mason fallback）
local function get_tsdk()
  local local_ts = vim.fn.getcwd() .. "/node_modules/typescript/lib"
  if vim.fn.isdirectory(local_ts) == 1 then
    return local_ts
  end
  local ok, mr = pcall(require, "mason-registry")
  if ok then
    local pkg = mr.get_package("typescript-language-server")
    if pkg and pkg:is_installed() then
      return pkg:get_install_path() .. "/node_modules/typescript/lib"
    end
  end
  return nil
end

-- -- ✅ CLEAN setup_handlers（role separation）
-- mason_lspconfig.setup_handlers({
--   function(server)
--     local opt = { on_attach = on_attach, capabilities = capabilities }
--
--     if server == "volar" then
--       -- Vue専用（.vueのみ）
--       opt.filetypes = { "vue" }
--       local tsdk = get_tsdk()
--       opt.init_options = {
--         typescript = tsdk and { tsdk = tsdk } or {},
--         vue = { hybridMode = false },
--       }
--       lspconfig.volar.setup(opt)
--       vim.notify("✅ Volar configured for Vue files only", vim.log.levels.INFO)
--       return
--     end
--
--     if server == "vtsls" then
--       -- TS/JS専用（vueは含めない）
--       opt.filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" }
--       opt.root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "nuxt.config.ts", "nuxt.config.js", ".git")
--       lspconfig.vtsls.setup(opt)
--       vim.notify("✅ VTSLS configured for TS/JS files only", vim.log.levels.INFO)
--       return
--     end
--
--     if server == "ts_ls" then
--       vim.notify("⚠️ Skipping ts_ls (using vtsls instead)", vim.log.levels.WARN)
--       return
--     end
--
--     if server == "lua_ls" then
--       opt.settings = {
--         Lua = {
--           diagnostics = { globals = { 'vim' } },
--           workspace = {
--             library = vim.api.nvim_get_runtime_file("", true),
--             checkThirdParty = false,
--           },
--           telemetry = { enable = false },
--         }
--       }
--     end
--
--     if server == "rust_analyzer" then
--       opt.settings = {
--         ["rust-analyzer"] = {
--           cargo = { loadOutDirsFromCheck = true },
--           procMacro = { enable = true },
--         }
--       }
--     end
--
--     lspconfig[server].setup(opt)
--     vim.notify("✅ LSP configured: " .. server, vim.log.levels.INFO)
--   end,
-- })
--
-- vim.notify("🎉 Clean LSP configuration loaded successfully", vim.log.levels.INFO)

-- mason 初期化（※一度だけ）
require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = { "volar" },  -- vtsls等は任意
  -- mason-lspconfig v2 は auto enable がデフォ（必要なら automatic_enable=true）
})

local vue_ls_path = vim.fn.expand("$MASON/packages/vue-language-server")
local vue_plugin_path = vue_ls_path .. "/node_modules/@vue/language-server"

-- Now configure ts_ls (TypeScript) to load the Vue plugin
require("lspconfig").ts_ls.setup({
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vue_plugin_path,
        languages = { "vue" },
      },
    },
  },
  filetypes = { "typescript", "javascript", "vue" },
})

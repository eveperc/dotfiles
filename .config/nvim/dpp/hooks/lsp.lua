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
  ensure_installed = {"intelephense","gopls" },  -- vtsls等は任意
  automatic_installation = true,
  handlers = {
    -- デフォルトハンドラ
    function(server_name)
      -- intelephense は除外（手動設定するため）
      if server_name == "intelephense" then
        return
      end
      lspconfig[server_name].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
  },
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


lspconfig.gopls.setup({
  on_attach = on_attach,  -- 既存の on_attach 関数を使用
  capabilities = capabilities,  -- 既存の capabilities を使用
  settings = {
    gopls = {
      -- 正しいオブジェクト形式で設定
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
        shadow = true,
        -- fieldalignment = true,
        nilness = true,
        unusedwrite = true,
        useany = true,
      },
      staticcheck = true,
      gofumpt = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
})



----------------------------------------------------------------------
-- PHP / Intelephense：重複起動を強制的に防ぐ
----------------------------------------------------------------------

-- (A) すでに起動している intelephense があれば一旦全部止める
for _, client in ipairs(vim.lsp.get_active_clients()) do
  if client.name == "intelephense" then
    client.stop(true)
  end
end

-- (B) LspAttach 時に重複が発生したら、"設定が空の方" を優先停止するガード
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("IntelephenseDeduper", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "intelephense" then return end

    local all = vim.lsp.get_active_clients({ name = "intelephense" })
    if #all <= 1 then return end

    -- includePaths が設定されている方をキープ、ない方を停止
    local function has_include_paths(c)
      local s = c.config and c.config.settings
      local i = s and s.intelephense
      local e = i and i.environment
      local p = e and e.includePaths
      return type(p) == "table" and #p > 0
    end

    local keep, kill = nil, {}
    for _, c in ipairs(all) do
      if has_include_paths(c) and not keep then
        keep = c
      else
        table.insert(kill, c)
      end
    end
    -- 万一両方空なら先着だけ残す
    if not keep and #all > 0 then
      keep = all[1]
      kill = {}
      for i = 2, #all do table.insert(kill, all[i]) end
    end

    for _, c in ipairs(kill) do
      c.stop(true)
    end
  end,
})

-- (C) 既定登録をクリアして、以降は自前設定のみ通す（後からsetupされても即A/Bで止まる）
pcall(function()
  local configs = require("lspconfig.configs")
  configs.intelephense = nil
end)

-- (D) 自前の Intelephense 設定（WordPress向け）
do
  local util = require("lspconfig.util")
  local root_pattern = util.root_pattern("composer.json", "wp-config.php", ".git")

  -- root_dir に応じて vendor/php-stubs を動的解決（テーマ直下オープンにも対応）
  local function compute_include_paths(root_dir)
    local found, join = {}, util.path.join
    local candidates = {
      join(root_dir, "vendor/php-stubs/wordpress-stubs"),
      join(root_dir, "vendor/php-stubs/wordpress-globals"),
      -- join(root_dir, "vendor/php-stubs/wordpress-tests-stubs"),
    }
    for _, p in ipairs(candidates) do
      if vim.loop.fs_stat(p) then table.insert(found, p) end
    end
    if #found == 0 then
      local parent = util.path.dirname(root_dir)
      local up_candidates = {
        join(parent, "vendor/php-stubs/wordpress-stubs"),
        join(parent, "vendor/php-stubs/wordpress-globals"),
      }
      for _, p in ipairs(up_candidates) do
        if vim.loop.fs_stat(p) then table.insert(found, p) end
      end
    end
    return found
  end

  lspconfig.intelephense.setup({
    on_attach = on_attach,
    capabilities = capabilities,

    root_dir = function(fname)
      return root_pattern(fname) or util.path.dirname(fname)
    end,

    -- root_dir 決定後に includePaths を注入（相対ズレ対策）
    on_new_config = function(new_config, new_root)
      local include_paths = compute_include_paths(new_root)
      new_config.settings = new_config.settings or {}
      new_config.settings.intelephense = new_config.settings.intelephense or {}
      new_config.settings.intelephense.environment =
        new_config.settings.intelephense.environment or {}
      new_config.settings.intelephense.environment.includePaths = include_paths
    end,

    settings = {
      intelephense = {
        -- WPスタブ + よく使う拡張のスタブ
        stubs = {
          "wordpress", "apache", "bcmath", "bz2", "calendar", "curl", "date",
          "dom", "filter", "ftp", "hash", "iconv", "imap", "intl", "json",
          "mbstring", "openssl", "pcntl", "pcre", "PDO", "pdo_mysql", "pdo_sqlite",
          "pgsql", "phar", "posix", "readline", "redis", "Reflection",
          "session", "SimpleXML", "soap", "sockets", "sodium", "SPL",
          "standard", "tokenizer", "xml", "xmlreader", "xmlwriter", "zlib",
        },

        -- コアの二重定義を避ける（wp-admin / wp-includes を除外）
        files = {
          maxSize = 5000000,
          exclude = {
            "**/.git/**",
            "**/node_modules/**",
            "**/wp-admin/**",
            "**/wp-includes/**",
          },
        },

        diagnostics = { enable = true },

        environment = {
          phpVersion = "8.2", -- 実行環境に合わせて
          -- includePaths は on_new_config で注入
        },

        format = { enable = false }, -- 別フォーマッタ使用時は false 推奨
      },
    },
  })
end


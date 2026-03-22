----------------------------------------------------------------------
-- LSP 設定 (nvim 0.11+ vim.lsp.config API)
----------------------------------------------------------------------

-- 共通capabilities
local capabilities = (function()
  local cap = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp = pcall(require, "cmp_nvim_lsp")
  return ok and cmp.default_capabilities(cap) or cap
end)()

-- 共通キーマッピング（LspAttach autocmd）
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    vim.notify("LSP attached: " .. client.name .. " to buffer " .. args.buf, vim.log.levels.INFO)

    local opts = { noremap = true, silent = true, buffer = args.buf }
    vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
    vim.keymap.set("n", "gr", "<cmd>Lspsaga finder<CR>", opts)
    vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)
    vim.keymap.set("n", "ga", "<cmd>Lspsaga code_action<CR>", opts)
    vim.keymap.set("n", "gn", "<cmd>Lspsaga rename<CR>", opts)
    vim.keymap.set("n", "ge", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
    vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
    vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
  end,
})

----------------------------------------------------------------------
-- ts_ls（TypeScript + Vue plugin）
----------------------------------------------------------------------
local vue_ls_path = vim.fn.expand("$MASON/packages/vue-language-server")
local vue_plugin_path = vue_ls_path .. "/node_modules/@vue/language-server"

vim.lsp.config("ts_ls", {
  capabilities = capabilities,
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

----------------------------------------------------------------------
-- gopls
----------------------------------------------------------------------
vim.lsp.config("gopls", {
  capabilities = capabilities,
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
        shadow = true,
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
  root_markers = { "go.work", "go.mod", ".git" },
})

----------------------------------------------------------------------
-- PHP / Intelephense（WordPress向け）
----------------------------------------------------------------------

-- root_dir に応じて vendor/php-stubs を動的解決
local function compute_include_paths(root_dir)
  local found = {}
  local candidates = {
    root_dir .. "/vendor/php-stubs/wordpress-stubs",
    root_dir .. "/vendor/php-stubs/wordpress-globals",
  }
  for _, p in ipairs(candidates) do
    if vim.uv.fs_stat(p) then table.insert(found, p) end
  end
  if #found == 0 then
    local parent = vim.fn.fnamemodify(root_dir, ":h")
    local up_candidates = {
      parent .. "/vendor/php-stubs/wordpress-stubs",
      parent .. "/vendor/php-stubs/wordpress-globals",
    }
    for _, p in ipairs(up_candidates) do
      if vim.uv.fs_stat(p) then table.insert(found, p) end
    end
  end
  return found
end

vim.lsp.config("intelephense", {
  capabilities = capabilities,
  root_markers = { "composer.json", "wp-config.php", ".git" },

  -- 起動時に includePaths を動的注入
  on_init = function(client)
    local root = client.config.root_dir
    if not root then return end

    local include_paths = compute_include_paths(root)
    if #include_paths > 0 then
      client.config.settings.intelephense.environment.includePaths = include_paths
      client:notify("workspace/didChangeConfiguration", {
        settings = client.config.settings,
      })
    end
  end,

  settings = {
    intelephense = {
      stubs = {
        "wordpress", "apache", "bcmath", "bz2", "calendar", "curl", "date",
        "dom", "filter", "ftp", "hash", "iconv", "imap", "intl", "json",
        "mbstring", "openssl", "pcntl", "pcre", "PDO", "pdo_mysql", "pdo_sqlite",
        "pgsql", "phar", "posix", "readline", "redis", "Reflection",
        "session", "SimpleXML", "soap", "sockets", "sodium", "SPL",
        "standard", "tokenizer", "xml", "xmlreader", "xmlwriter", "zlib",
      },
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
        phpVersion = "8.2",
        includePaths = {},
      },
      format = { enable = false },
    },
  },
})

----------------------------------------------------------------------
-- Intelephense 重複起動ガード
----------------------------------------------------------------------

-- すでに起動している intelephense があれば止める
for _, client in ipairs(vim.lsp.get_clients()) do
  if client.name == "intelephense" then
    client:stop()
  end
end

-- LspAttach 時の重複チェック
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("IntelephenseDeduper", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "intelephense" then return end

    local all = vim.lsp.get_clients({ name = "intelephense" })
    if #all <= 1 then return end

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
    if not keep and #all > 0 then
      keep = all[1]
      kill = {}
      for i = 2, #all do table.insert(kill, all[i]) end
    end

    for _, c in ipairs(kill) do
      c:stop()
    end
  end,
})

----------------------------------------------------------------------
-- 全サーバー有効化
----------------------------------------------------------------------
vim.lsp.enable({ "ts_ls", "gopls", "intelephense" })

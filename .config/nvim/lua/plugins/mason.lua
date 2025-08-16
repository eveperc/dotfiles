local status, mason = pcall(require, 'mason')
local vim = vim
local home_dir = os.getenv("HOME")
if (not status) then return end

mason.setup()

local nvim_lsp = require('lspconfig')
local status, mason_lspconfig = pcall(require, 'mason-lspconfig')
if (not status) then return end

-- Mason setup
mason.setup()

-- Ensure Volar is installed
mason_lspconfig.setup({
  -- ensure_installed = { "vue-language-server" },
  automatic_enable = false, -- Disable automatic server enabling
})

local function on_attach(server, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }

  if server == "intelephense" then
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  elseif server == "rust_analyzer" then
    vim.api.nvim_buf_set_option(bufnr, 'shiftwidth', 4)
    vim.api.nvim_buf_set_option(bufnr, 'tabstop', 4)
    vim.api.nvim_buf_set_option(bufnr, 'expandtab', true)
  end
end
-- Manual server configuration after initialization
vim.defer_fn(function()
  local servers = mason_lspconfig.get_installed_servers()
  for _, server in ipairs(servers) do
      local opt = {
        on_attach = function(client, bufnr)
          on_attach(server, bufnr)
        end,
        capabilities = require('cmp_nvim_lsp').default_capabilities(
          vim.lsp.protocol.make_client_capabilities()
        )
      }

      if server == "intelephense" then
        opt.settings = {
          intelephense = {
            environment = {
              phpVersion = "8.2",
              includePaths = { home_dir .. '/.config/composer/vendor/php-stubs/wordpress-stubs' },
            },
            completion = {
              fullyQualifyGlobalConstantsAndFunctions = true
            },
            format = {
              enable = true,
              braces = "PSR12",
              on_save = true,
            },
            stubs = {
              "bcmath",
              "bz2",
              "calendar",
              "Core",
              "ctype",
              "curl",
              "date",
              "dom",
              "fileinfo",
              "filter",
              "ftp",
              "hash",
              "iconv",
              "json",
              "mbstring",
              "pcntl",
              "pcre",
              "Phar",
              "posix",
              "readline",
              "Reflection",
              "session",
              "SimpleXML",
              "standard",
              "Swoole",
              "tokenizer",
              "xml",
              "zip",
              "zlib",
              "wordpress",
              -- 'wordpress-stubs',
            },
          }
        }
        -- opt.on_attach = function(client, bufnr)
        --   vim.api.nvim_buf_set_option(bufnr, 'shiftwidth', 4)
        -- end
  elseif server == "ts_ls" then
    opt.single_file_support = false

    -- Mason 2.0対応: vim.fn.expand "$MASON" を使用
    local vue_typescript_plugin = vim.fn.expand "$MASON" .. "/packages/vue-language-server" ..
        "/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin"

    -- パスが存在するか確認し、存在しない場合は別のパスを試す
    if vim.fn.isdirectory(vue_typescript_plugin) == 0 then
        -- 短いパスを試す
        vue_typescript_plugin = vim.fn.expand "$MASON" .. "/packages/vue-language-server" ..
            "/node_modules/@vue/typescript-plugin"
    end

    opt.filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
    opt.init_options = {
        plugins = {
            {
                name = '@vue/typescript-plugin',
                location = vue_typescript_plugin,
                languages = { 'vue' },
            }
        }
    }
    opt.root_dir = nvim_lsp.util.root_pattern("nuxt.config.ts", "tsconfig.json", "package.json", ".git")
  elseif server == "denols" then
    if is_node_repo then
      return
    end
    opt.root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json")
    opt.init_options = {
      lint = true,
      unstable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://deno.land"] = true,
            ["https://cdn.nest.land"] = true,
            ["https://crux.land"] = true
          }
        }
      }
    }
      elseif server == "volar" then
        -- Volar configuration for Vue 3
        opt.filetypes = { "vue" }
        opt.init_options = {
          typescript = {
            tsdk = vim.fn.expand "$MASON" .. "/packages/typescript-language-server/node_modules/typescript/lib"
          }
        }
      elseif server == "clangd" then
        opt.cmd = { "clangd", "--background-index" }
        opt.filetypes = { "c", "cpp", "objc", "objcpp" }
        opt.root_dir = nvim_lsp.util.root_pattern("compile_flags.txt", ".clangd")
        opt.init_options = {
          clangdFileStatus = true
        }
      elseif server == "rust_analyzer" then
        opt.root_dir = nvim_lsp.util.root_pattern("Cargo.toml", "rust-project.json")
        opt.settings = {
          ["rust-analyzer"] = {
            cargo = {
              loadOutDirsFromCheck = true
            },
            procMacro = {
              enable = true
            },
          }
        }
      end
      require('lspconfig')[server].setup(opt)
      ::continue::
  end
end, 100)

-- LSP configuration hooks
-- This file contains the configuration that was in plugin/mason.lua

local home_dir = os.getenv("HOME")

-- Mason setup
require("mason").setup()

require("mason-lspconfig").setup({
  automatic_installation = true,
})

local nvim_lsp = require('lspconfig')

local function on_attach(server, bufnr)
  if server == "gopls" then
    vim.api.nvim_buf_set_option(bufnr, 'tabstop', 4)
    vim.api.nvim_buf_set_option(bufnr, 'shiftwidth', 4)
    vim.api.nvim_buf_set_option(bufnr, 'expandtab', false)
  elseif server == "pyright" or server == "pylsp" then
    vim.api.nvim_buf_set_option(bufnr, 'tabstop', 4)
    vim.api.nvim_buf_set_option(bufnr, 'shiftwidth', 4)
    vim.api.nvim_buf_set_option(bufnr, 'expandtab', true)
  end
end

-- Server configurations
local servers = require("mason-lspconfig").get_installed_servers()
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
          "bcmath", "bz2", "calendar", "Core", "ctype", "curl",
          "date", "dom", "fileinfo", "filter", "ftp", "hash",
          "iconv", "json", "mbstring", "pcntl", "pcre", "Phar",
          "posix", "readline", "Reflection", "session", "SimpleXML",
          "standard", "Swoole", "tokenizer", "xml", "zip", "zlib",
          "wordpress",
        },
      }
    }
  elseif server == "ts_ls" then
    opt.single_file_support = false
    local vue_typescript_plugin = vim.fn.expand "$MASON" .. "/packages/vue-language-server" ..
        "/node_modules/@vue/typescript-plugin"
    
    if vim.fn.isdirectory(vue_typescript_plugin) == 0 then
        vue_typescript_plugin = vim.fn.expand "$MASON" .. "/packages/vue-language-server" ..
            "/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin"
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
    opt.root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc")
  elseif server == "lua_ls" then
    opt.settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }
        }
      }
    }
  elseif server == "volar" then
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
  
  nvim_lsp[server].setup(opt)
end
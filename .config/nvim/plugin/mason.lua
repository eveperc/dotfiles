local status, mason = pcall(require, 'mason')
if (not status) then return end

mason.setup()

local status, mason_lspconfig = pcall(require, 'mason-lspconfig')
if (not status) then return end

mason_lspconfig.setup_handlers({ function(server)
  local opt = {
    on_attach = function(client, bufnr)
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>")
      vim.keymap.set('n', 'gr', '<cmd>Lspsaga lsp_finder<CR>')
      vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
      vim.keymap.set("n", "ga", "<cmd>Lspsaga code_action<CR>")
      vim.keymap.set("n", "gn", "<cmd>Lspsaga rename<CR>")
      vim.keymap.set("n", "ge", "<cmd>Lspsaga show_line_diagnostics<CR>")
      vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>")
      vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
    end,
    capabilities = require('cmp_nvim_lsp').default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    )
  }
  if server == "intelephense" then
    require 'lspconfig'.intelephense.setup {
      default_config = {
        cmd = { 'intelephense', '--stdio' };
        -- on_attach = require 'lsp'.common_on_attach;
        filetypes = { 'php' };
        root_dir = function(fname)
          return vim.loop.cwd()
        end;
        settings = {
          intelephense = {
            environment = {
              phpVersion = "8.1",
              includePaths = {'/home/ibusuki/.config/composer/vendor/php-stubs/'},
            },
            completion = {
              fullyQualifyGlobalConstantsAndFunctions = true
            },
            format = {
              enable = true
            },
            stubs = {
              -- "bcmath",
              -- "bz2",
              -- "calendar",
              -- "Core",
              -- "curl",
              -- "zip",
              -- "zlib",
              "wordpress",
              -- "woocommerce",
              -- "acf-pro",
              "wordpress-globals",
              "wp-cli",
              -- "genesis",
              -- "polylang",
              "wp-cli-stubs",
              -- "genesis-stubs",
              'wordpress-stubs',
            },
          }
        }
      },
      opt
    }
  end
  require('lspconfig')[server].setup(opt)
end })

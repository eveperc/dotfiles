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
      vim.keymap.set('n', 'gr', '<cmd>Lspsaga finder<CR>')
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
    opt.settings = {
      intelephense = {
        environment = {
          phpVersion = "8.1",
          includePaths = { '/home/eveperc/.config/composer/vendor/php-stubs/wordpress-stubs' },
        },
        completion = {
          fullyQualifyGlobalConstantsAndFunctions = true
        },
        format = {
          enable = true
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
  end
  require('lspconfig')[server].setup(opt)
end })

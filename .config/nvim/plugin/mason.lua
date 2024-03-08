local status, mason = pcall(require, 'mason')
local vim = vim
if (not status) then return end

mason.setup()

local nvim_lsp = require('lspconfig')
local status, mason_lspconfig = pcall(require, 'mason-lspconfig')
if (not status) then return end

require('mason-lspconfig').setup({
  ensure_installed = { "volar", "tsserver" }
})

local function on_attach(server, bufnr)
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
  if server == "intelephense" then
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  end
end
mason_lspconfig.setup_handlers({ function(server)
  local node_root_dir = nvim_lsp.util.root_pattern("package.json")
  local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0)) ~= nil
  local bufnr = vim.api.nvim_get_current_buf()
  local opt = {
    on_attach = on_attach(server, bufnr),
    capabilities = require('cmp_nvim_lsp').default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    )
  }

  if server == "intelephense" then
    opt.settings = {
      intelephense = {
        environment = {
          phpVersion = "8.2",
          includePaths = { '/home/katsunori-ibusuki/.config/composer/vendor/php-stubs/wordpress-stubs' },
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
    opt.on_attach = function(client, bufnr)
      vim.api.nvim_buf_set_option(bufnr, 'shiftwidth', 4)
    end
  elseif server == "volar" then
    opt.filetypes = { "vue", "javascript", "typescript" }
    -- elseif server == "tsserver" then
    --     if not is_node_repo then
    --         return
    --     end
    --
    --     opt.root_dir = node_root_dir
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
  end
  require('lspconfig')[server].setup(opt)
end })

local fn = vim.fn

local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  return
end

return lazy.setup({
  -- lsp
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
      }
    },
    -- your lsp config or other stuff
  },
  {
    'nvimdev/lspsaga.nvim',
    event = 'BufRead',
    config = function()
      require('lspsaga').setup({})
    end,
    dependencies = { { 'nvim-web-devicons' } }
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  -- linter
  {
    'creativenull/efmls-configs-nvim',
    version = 'v0.2.x', -- tag is optional
    dependencies = { 'neovim/nvim-lspconfig' },
  },
  -- -- mason
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  -- devicon
  { "nvim-tree/nvim-web-devicons" },
  { 'ryanoasis/vim-devicons' },
  -- nvim-lualine/lualine.nvim
  {
    'nvim-lualine/lualine.nvim',
    ft = "norg",
    config = function()
      require('nvim-web-devicons').setup()
    end,
  },
  --tabline
  {
    'akinsho/bufferline.nvim',
    config = function()
      require('nvim-web-devicons').setup()
    end,
  },
  -- git
  { "tpope/vim-fugitive" },
  { "airblade/vim-gitgutter" },
  {
    "aaronhallaert/advanced-git-search.nvim",
    config = function()
      -- optional: setup telescope before loading the extension
      require("telescope").setup {
        -- move this to the place where you call the telescope setup function
        extensions = {
          advanced_git_search = {
            -- fugitive or diffview
            diff_plugin = "fugitive",
            -- customize git in previewer
            -- e.g. flags such as { "--no-pager" }, or { "-c", "delta.side-by-side=false" }
            git_flags = {},
            -- customize git diff in previewer
            -- e.g. flags such as { "--raw" }
            git_diff_flags = {},
          }
        }
      }

      require("telescope").load_extension("advanced_git_search")
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      -- to show diff splits and open commits in browser
      "tpope/vim-fugitive",
      -- to open commits in browser with fugitive
      "tpope/vim-rhubarb",
      -- OPTIONAL: to replace the diff from fugitive with diffview.nvim
      -- (fugitive is still needed to open in browser)
      -- "sindrets/diffview.nvim",
    },
  },
  { 'f-person/git-blame.nvim' },

  -- colorscheme
  { 'ray-x/aurora' },
  { 'luisiacc/gruvbox-baby' },
  { 'tiagovla/tokyodark.nvim' },
  { 'kdheepak/monochrome.nvim' },
  { 'titanzero/zephyrium' },
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    -- Optional; default configuration will be used if setup isn't called.
    config = function()
      require("everforest").setup({
        -- Your config here
      })
    end,
  },
  {
    'nvimdev/zephyr-nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', opt = true },
  },
  -- fzf
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({})
    end
  },
  { "junegunn/fzf",         build = "./install --bin" },
  -- lua module
  { "nvim-lua/plenary.nvim" },

  -- 自動補完プラグイン
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("cmp").setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = {
          { name = "luasnip" },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
          { name = "cmdline" },
        },
      })
    end,
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { "hrsh7th/cmp-nvim-lsp-document-symbol" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/vim-vsnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "onsails/lspkind.nvim" },
      { "cmp_luasnip" },
      { "L3MON4D3/LuaSnip" },
      { "rafamadriz/friendly-snippets" },
    },
  },
  -- lsp用の補完
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  { "hrsh7th/cmp-nvim-lsp-document-symbol" },
  -- バッファー補完
  { "hrsh7th/cmp-buffer" },
  -- パス補完
  { "hrsh7th/cmp-path" },
  -- コマンドライン補完
  { "hrsh7th/cmp-cmdline" },
  -- スニペット補完
  { "hrsh7th/vim-vsnip" },
  -- cmpで補完する際に表示されるアイコンを設定
  { "onsails/lspkind.nvim" },
  -- copilot補完
  {
    "zbirenbaum/copilot-cmp",

  },

  -- file explorer
  {
    "tamago324/lir.nvim",
    ft = "norg",
    config = function()
      require('nvim-web-devicons').setup()
    end,
  },
  -- lazy.nvim
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      -- Others dependencies
      'saifulapm/neotree-file-nesting-config', -- add plugin as dependency. no need any other config or setup call
    },
    opts = {
      -- recommanded config for better UI
      hide_root_node = true,
      retain_hidden_root_indent = true,
      filesystem = {
        filtered_items = {
          show_hidden_count = false,
          never_show = {
            '.DS_Store',
          },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = '',
          expander_expanded = '',
        },
      },
      -- others config
    },
    config = function(_, opts)
      -- Adding rules from plugin
      opts.nesting_rules = require('neotree-file-nesting-config').nesting_rules
      require('neo-tree').setup(opts)
    end,
  },
  {
    "SmiteshP/nvim-navic",
    despendencies = "neovim/nvim-lspconfig"
  },

  -- treesitter
  { "nvim-treesitter/nvim-treesitter" },
  {
    "yioneko/nvim-yati",
    ft = "norg",
    config = function()
      require("nvim-treesitter").setup()
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  -- visual
  { "lukas-reineke/indent-blankline.nvim" },
  { "petertriho/nvim-scrollbar" },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = {
      -- options
    },
  },
  { "rcarriga/nvim-notify" },
  { "MunifTanjim/nui.nvim" },
  {
    "folke/noice.nvim",
    ft = "norg",
    config = function()
      require("nui.popup")
      require("nui.layout")
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      require("notify")
    end,
  },
  { "RRethy/vim-illuminate" },
  { "xiyaowong/nvim-cursorword" },

  -- moving
  {
    'smoka7/hop.nvim',
    version = "*",
    opts = {},
  },
  { "unblevable/quick-scope" },
  { "haya14busa/vim-edgemotion" },
  { "mfussenegger/nvim-treehopper" },
  { 'David-Kunz/treesitter-unit' },
  { 'machakann/vim-columnmove' },
  -- edit
  { 'numToStr/Comment.nvim' },
  { "windwp/nvim-autopairs" },
  { "machakann/vim-sandwich" },
  { "mattn/vim-sonictemplate" },
  {
    "folke/todo-comments.nvim",
    ft = "norg",
    config = function()
      require("plenary.nvim")
      require("todo-comments").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },
  {
    "chrisgrieser/nvim-alt-substitute",
    opts = true,
    -- lazy-loading with `cmd =` does not work well with incremental preview
    event = "CmdlineEnter",
  },
  -- terminal
  { "akinsho/toggleterm.nvim" },
  --mark
  {
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup(

      )
    end,
  },
  --dap
  { 'mfussenegger/nvim-dap' },
  { "rcarriga/nvim-dap-ui",   dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
  {
    'theHamsta/nvim-dap-virtual-text',
    config = function()
      require('nvim-dap-virtual-text').setup()
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  { 'segeljakt/vim-silicon' },
  { "github/copilot.vim" },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
  { "vim-denops/denops.vim" },
  { "previm/previm" },
  { "dense-analysis/ale" },
  -- Lua
  -- スニペット--
  { "rafamadriz/friendly-snippets" },
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  { 'saadparwaiz1/cmp_luasnip' },
  --color--
  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  { 'wakatime/vim-wakatime',   lazy = false }
})

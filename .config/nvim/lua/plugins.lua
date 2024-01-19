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

-- Install your plugins here
return lazy.setup({
  -- My plugins here
  -- lsp
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim"
        },
        opts = { lsp = { auto_attach = true } }
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
  -- linter
  -- { "jose-elias-alvarez/null-ls.nvim" },
  {
    'creativenull/efmls-configs-nvim',
    version = 'v0.2.x', -- tag is optional
    dependencies = { 'neovim/nvim-lspconfig' },
  },
  -- -- mason
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  -- devicon
  { "kyazdani42/nvim-web-devicons" },
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
    requires = { 'nvim-treesitter/nvim-treesitter', opt = true },
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
  -- nvim-cmp
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/vim-vsnip" },
  -- file explorer
  {
    "tamago324/lir.nvim",
    ft = "norg",
    config = function()
      require('nvim-web-devicons').setup()
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
  { 'rcarriga/nvim-dap-ui' },
  {
    'theHamsta/nvim-dap-virtual-text',
    config = function()
      require('nvim-dap-virtual-text').setup()
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    -- or                              , branch = '0.1.1',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  { 'segeljakt/vim-silicon' },
  { "github/copilot.vim" },
  { "vim-denops/denops.vim" },
  { "previm/previm" },
  { "dense-analysis/ale" }
})

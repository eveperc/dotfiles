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
  { "neovim/nvim-lspconfig" },
  {
    'glepnir/lspsaga.nvim',
    event = 'BufRead',
    config = function()
      require('lspsaga').setup({})
    end,
    dependencies = { { 'nvim-web-devicons' } }
  },
  -- linter
  {"jose-elias-alvarez/null-ls.nvim"},
  -- -- mason
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  -- devicon
  { "kyazdani42/nvim-web-devicons" },
  { 'ryanoasis/vim-devicons' },
  -- nvim-lualine/lualine.nvim
  { 'nvim-lualine/lualine.nvim',
    ft = "norg",
    config = function()
      require('nvim-web-devicons').setup()
    end,
  },
  --tabline
  { 'akinsho/bufferline.nvim',
    config = function()
      require('nvim-web-devicons').setup()
    end,
  },
  -- git
  { "tpope/vim-fugitive" },
  { "airblade/vim-gitgutter" },
  -- colorscheme
  { 'luisiacc/gruvbox-baby' },
  { 'tiagovla/tokyodark.nvim' },
  -- fzf
  { "ibhagwan/fzf-lua" },
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
  { "tamago324/lir.nvim",
    ft = "norg",
    config = function()
      require('nvim-web-devicons').setup()
    end,
  },

  -- treesitter
  { "nvim-treesitter/nvim-treesitter" },
  { "yioneko/nvim-yati",
    ft = "norg",
    config = function()
      require("nvim-treesitter").setup()
    end,
  },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  -- visual
  { "lukas-reineke/indent-blankline.nvim" },
  { "mvllow/modes.nvim",
    tag = "v0.2.0"
  },
  { "petertriho/nvim-scrollbar" },
  { "j-hui/fidget.nvim" },
  { "rcarriga/nvim-notify" },
  { "MunifTanjim/nui.nvim" },
  { "folke/noice.nvim",
    ft = "norg",
    config = function()
      require("nui.popup")
      require("nui.layout")
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      require("notify").setup()
    end,
  },
  { 'sunjon/shade.nvim',
    config = function()
      require("shade").setup({
        overlay_opacity = 50,
        opacity_step = 1,
        keys = {
          brightness_up   = '<C-Up>',
          brightness_down = '<C-Down>',
          toggle          = '<Leader>s',
        },
      })
    end
  },
  { "RRethy/vim-illuminate" },
  -- { "xiyaowong/nvim-transparent" },
  --activity
  { 'wakatime/vim-wakatime' },
  -- moving
  {
    "phaazon/hop.nvim",
    branch = "v2", -- optional but strongly recommended
  },
  -- { "unblevable/quick-scope"},
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
  -- terminal
  { "akinsho/toggleterm.nvim" },
  --mark
  { 'chentoast/marks.nvim',
    config = function()
      require('marks').setup(

      )
    end,
  },
  -- markdown
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
  --dap
  { 'mfussenegger/nvim-dap' },
  { 'rcarriga/nvim-dap-ui' },
  { 'theHamsta/nvim-dap-virtual-text',
    config = function()
      require('nvim-dap-virtual-text').setup()
    end,
  }
})

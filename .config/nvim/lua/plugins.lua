local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here

  -- packer
  use({ "wbthomason/packer.nvim" })
  -- lsp
  use({ "neovim/nvim-lspconfig" })
  use({
    "glepnir/lspsaga.nvim",
    branch = "main",

    config = function()
      require("lspsaga").setup({})

      -- saga.init_lsp_saga({
      --   saga_winblend = 0,
      --   custom_kind = {
      --     Field = '#000000',
      --   },

      -- })
    end,

  })
  use({ "lukas-reineke/indent-blankline.nvim" })
  -- -- mason
  use({ "williamboman/mason.nvim" })
  use({ "williamboman/mason-lspconfig.nvim" })

  -- nvim-lualine/lualine.nvim
  use({ 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } })
  --tabline
  use { 'akinsho/bufferline.nvim', tag = "v3.*", requires = 'kyazdani42/nvim-web-devicons' }
  -- git
  use({ "tpope/vim-fugitive" })
  use({ "airblade/vim-gitgutter" })
  -- colorscheme
  use({ 'luisiacc/gruvbox-baby' })
  use({ 'tiagovla/tokyodark.nvim' })
  -- fzf
  use({ "obaland/vfiler.vim" })
  use({ "obaland/vfiler-fzf" })
  use({ "ibhagwan/fzf-lua" })
  -- nvim-cmp
  use({ "hrsh7th/nvim-cmp" })
  use({ "hrsh7th/cmp-path" })
  use({ "hrsh7th/cmp-buffer" })
  use({ "hrsh7th/cmp-cmdline" })
  use({ "hrsh7th/cmp-nvim-lsp" })
  use({ "hrsh7th/vim-vsnip" })
  -- file explorer
  use({ "tamago324/lir.nvim", requires = 'kyazdani42/nvim-web-devicons' })
  -- lua module
  use({ "nvim-lua/plenary.nvim" })
  -- devicon
  use({ "kyazdani42/nvim-web-devicons" })
  use({ 'ryanoasis/vim-devicons' })
  -- treesitter
  use({ "nvim-treesitter/nvim-treesitter" })
  use({ "yioneko/nvim-yati", tag = "*", requires = "nvim-treesitter/nvim-treesitter" })
  use({ "nvim-treesitter/nvim-treesitter-context" })
  use({ "nvim-treesitter/nvim-treesitter-textobjects" })
  -- marks
  use({ 'ThePrimeagen/harpoon' })
  -- visual
  use({ "mvllow/modes.nvim", tag = "v0.2.0" })
  use({ "petertriho/nvim-scrollbar" })
  use({ "j-hui/fidget.nvim" })
  use({ "folke/noice.nvim",
    requires = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  })
  use({ "RRethy/vim-illuminate" })
  --activity
  use({ 'wakatime/vim-wakatime' })
  -- moving
  use({
    "phaazon/hop.nvim",
    branch = "v2", -- optional but strongly recommended
  })
  use({ "unblevable/quick-scope" })
  use({ "mfussenegger/nvim-treehopper" })
  use({ 'David-Kunz/treesitter-unit' })
  -- edit
  use({ 'numToStr/Comment.nvim' })
  use({ "windwp/nvim-autopairs" })
  use({ "machakann/vim-sandwich" })
  use({ "mattn/vim-sonictemplate" })
  use({ "LudoPinelli/comment-box.nvim" })
  use({
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  })
  use({
    "AckslD/nvim-neoclip.lua",
    requires = {
      -- you'll need at least one of these
      -- {'nvim-telescope/telescope.nvim'},
      -- {'ibhagwan/fzf-lua'},
    },
    config = function()
      require('neoclip').setup()
    end,
  })
  -- terminal
  use({ "akinsho/toggleterm.nvim", tag = '*' })
  -- markdown
  use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install",
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

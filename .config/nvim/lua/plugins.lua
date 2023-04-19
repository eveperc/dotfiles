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
    'glepnir/lspsaga.nvim',
    event = 'BufRead',
    config = function()
      require('lspsaga').setup({})
    end,
    dependencies = { { 'nvim-web-devicons' } }
  },
  -- linter
  { "jose-elias-alvarez/null-ls.nvim" },
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
  {
    "SmiteshP/nvim-navic",
    despendencies = "neovim/nvim-lspconfig"
  },

  -- treesitter
  { "nvim-treesitter/nvim-treesitter" },
  { "yioneko/nvim-yati",
    ft = "norg",
    config = function()
      require("nvim-treesitter").setup()
    end,
  },
  -- { "nvim-treesitter/nvim-treesitter-context" },
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
      require("notify")
    end,
  },
  { "RRethy/vim-illuminate" },
  -- { "levouh/tint.nvim",
  --   config = function()
  --     require("tint").setup({
  --       tint = -45, -- Darken colors, use a positive value to brighten
  --       saturation = 0.6, -- Saturation to preserve
  --       transforms = require("tint").transforms.SATURATE_TINT, -- Showing default behavior, but value here can be predefined set of transforms
  --       tint_background_colors = true, -- Tint background portions of highlight groups
  --       highlight_ignore_patterns = { "WinSeparator", "Status.*" }, -- Highlight group patterns to ignore, see `string.find`
  --       window_ignore_function = function(winid)
  --         local bufid = vim.api.nvim_win_get_buf(winid)
  --         local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
  --         local floating = vim.api.nvim_win_get_config(winid).relative ~= ""
  --
  --         -- Do not tint `terminal` or floating windows, tint everything else
  --         return buftype == "terminal" or floating
  --       end
  --     })
  --   end
  -- },
  --activity
  { 'wakatime/vim-wakatime' },
  -- moving
  {
    "phaazon/hop.nvim",
    branch = "v2", -- optional but strongly recommended
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
  { 'chentoast/marks.nvim',
    config = function()
      require('marks').setup(

      )
    end,
  },
  -- markdown
  { 'iamcco/markdown-preview.nvim',
    config = function()
      vim.fn["mkdp#util#install"]()
    end
  },
  --dap
  { 'mfussenegger/nvim-dap' },
  { 'rcarriga/nvim-dap-ui' },
  { 'theHamsta/nvim-dap-virtual-text',
    config = function()
      require('nvim-dap-virtual-text').setup()
    end,
  },
  --chatGPT
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    -- or                              , branch = '0.1.1',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "jackMort/ChatGPT.nvim",
    config = function()
      require("chatgpt").setup({
        -- optional configuration
        keymaps = {
          close = { "<C-c>" },
          submit = "<Enter>",
        }
      })
    end,
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
})

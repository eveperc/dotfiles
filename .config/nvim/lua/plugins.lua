--[[
このファイルは、lazy.nvimを使用してNeovimのプラグインを管理します。
プラグインは機能ごとにグループ化されており、必要に応じて設定されています。

主なプラグイングループ:
1. LSP関連
   - nvim-lspconfig: LSPの基本設定
   - lspsaga: LSPのUI改善
   - mason: LSPサーバー管理

2. 補完機能
   - nvim-cmp: 補完エンジン
   - copilot: AI補完
   - LuaSnip: スニペット

3. UI/表示
   - nvim-web-devicons: ファイルアイコン
   - lualine: ステータスライン
   - bufferline: タブライン
   - noice/notify: 通知UI

4. Git連携
   - vim-fugitive: Git操作
   - vim-gitgutter: 差分表示
   - advanced-git-search: Git検索

5. ファイル操作
   - lir.nvim: ファイルエクスプローラ
   - fzf-lua: ファジーファインダー

6. 編集支援
   - hop.nvim: カーソル移動
   - nvim-treesitter: 構文解析
   - Comment.nvim: コメント操作
   - nvim-autopairs: 自動ペア入力

7. AI支援
   - avante.nvim: AIコーディング支援
   - codecompanion.nvim: AIコードレビュー
   - CopilotChat.nvim: AI対話

8. デバッグ
   - nvim-dap: デバッグ機能
   - nvim-dap-ui: デバッグUI

9. その他
   - カラースキーム
   - マークダウンプレビュー
   - ターミナル統合
--]]

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

-- =========================================================================
-- LSPとコード解析
-- =========================================================================
return lazy.setup({
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

  -- =========================================================================
  -- カラースキーム
  -- =========================================================================
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

  -- =========================================================================
  -- ファジーファインダー (fzf)
  -- =========================================================================
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

  -- =========================================================================
  -- 自動補完システム
  -- =========================================================================
  {
    "hrsh7th/nvim-cmp",
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
  { "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- =========================================================================
  -- ファイルエクスプローラとナビゲーション
  -- =========================================================================
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

  -- =========================================================================
  -- 構文解析とコード理解 (Treesitter)
  -- =========================================================================
  { "nvim-treesitter/nvim-treesitter" },
  {
    "yioneko/nvim-yati",
    ft = "norg",
    config = function()
      require("nvim-treesitter").setup()
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },

  -- =========================================================================
  -- ビジュアル強化
  -- =========================================================================
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

  -- =========================================================================
  -- カーソル移動と操作
  -- =========================================================================
  {
    'smoka7/hop.nvim',
    version = "*",
    opts = {},
  },
  { "unblevable/quick-scope" },
  { "haya14busa/vim-edgemotion" },
  { "mfussenegger/nvim-treehopper" },
  { 'David-Kunz/treesitter-unit' },
  -- { 'machakann/vim-columnmove' },

  -- =========================================================================
  -- 編集支援
  -- =========================================================================
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

  -- =========================================================================
  -- ターミナル統合
  -- =========================================================================
  { "akinsho/toggleterm.nvim" },

  -- =========================================================================
  -- マーク機能
  -- =========================================================================
  {
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup(

      )
    end,
  },

  -- =========================================================================
  -- デバッグ支援 (DAP)
  -- =========================================================================
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
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = false,
      },
      panel = {
        enabled = false,     -- 提案パネルを無効化してパフォーマンスを改善
      },
      copilot_node_command = 'node'
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
      { "ibhagwan/fzf-lua" },  -- fzf-luaを依存関係に追加
    },
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
  -- avante --
  {
  'stevearc/dressing.nvim',
    opts = {},
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      -- add options here
      -- or leave it empty to use the default settings
    },
    keys = {
      -- suggested keymap
    },
  },
  {
    "yetone/avante.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",  -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
                insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
    },
    enabled = true,
    -- event = "VeryLazy", -- 削除
    lazy = false,
    version = false,
    opts = {
      provider = "copilot",
      -- provider = "claude",
      -- provider = "openai",
      -- use_xml_format = true,
      auto_suggestions_provider = "copilot",
      behaviour = {
          -- auto_suggestions = true,
          -- auto_set_highlight_group = true,
          -- auto_set_keymaps = true,
          auto_apply_diff_after_generation = true,
          -- support_paste_from_clipboard = true,
      },
      -- behaviour = {
      --   auto_suggestions = false, -- Experimental stage
      --   auto_set_highlight_group = true,
      --   auto_set_keymaps = true,
      --   auto_apply_diff_after_generation = false,
      --   support_paste_from_clipboard = false,
      --   minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
      --   enable_token_counting = true, -- Whether to enable token counting. Default to true.
      --   enable_cursor_planning_mode = false, -- Whether to enable Cursor Planning Mode. Default to false.
      --   enable_claude_text_editor_tool_mode = false, -- Whether to enable Claude Text Editor Tool Mode.
      -- },
      windows = {
          position = "right",
          width = 30,
          sidebar_header = {
              align = "center",
              rounded = false,
          },
          ask = {
              floating = true,
              start_insert = true,
              border = "rounded"
          }
      },
      -- providers-setting
      claude = {
          model = "claude-3-5-sonnet-20240620", -- $3/$15, maxtokens=8000
          -- model = "claude-3-opus-20240229",  -- $15/$75
          -- model = "claude-3-haiku-20240307", -- $0.25/1.25
          max_tokens = 8000,
      },
      copilot = {
          -- model = "gpt-4o-mini",
          model = "claude-3.5-sonnet",
          -- max_tokens = 4096,
      },
      openai = {
          model = "gpt-4o", -- $2.5/$10
          -- model = "gpt-4o-mini", -- $0.15/$0.60
          max_tokens = 4096,
      },
    }
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
})

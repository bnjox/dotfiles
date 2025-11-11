return {
  -- ╔════════════════════════════════╗
  -- ║     PLUGIN: TOKYONIGHT        ║
  -- ╚════════════════════════════════╝
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      require("tokyonight").setup({
        styles = {
          functions = { italic = true },
          variables = { italic = true },
        },
      })

      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- ╔════════════════════════════════╗
  -- ║     PLUGIN: TREESITTER        ║
  -- ╚════════════════════════════════╝
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs", -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "css",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "sql",
        "svelte",
        "typescript",
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    },
  },

  -- ╔════════════════════════════════╗
  -- ║       PLUGIN: BLINK           ║
  -- ╚════════════════════════════════╝
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = "VeryLazy",
    version = "*",
    opts = {
      keymap = {
        preset = "super-tab",
        ["<CR>"] = { "accept", "fallback" },
      },

      signature = { enabled = true },
      completion = {
        accept = { auto_brackets = { enabled = false } },

        trigger = { show_in_snippet = false },

        list = {
          max_items = 100,
          selection = { preselect = true, auto_insert = false },
        },

        ghost_text = { enabled = true, show_with_menu = false },
      },

      cmdline = {
        keymap = {
          ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },
      },

      sources = {
        providers = {
          cmdline = {
            min_keyword_length = function(ctx)
              -- when typing a command, only show when the keyword is 3 characters or longer
              if ctx.mode == 'cmdline' and string.find(ctx.line, ' ') == nil then return 3 end
              return 0
            end
          }
        }
      }
    },
  },

  -- ╔════════════════════════════════╗
  -- ║     PLUGIN: BUFFERLINE        ║
  -- ╚════════════════════════════════╝
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, _, _)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
      },
    },
    keys = {
      { "<leader>bd", "<Cmd>bd<CR>",                  desc = "Delete Current Buffer", mode = "n" },
      { "<leader>bn", "<Cmd>BufferLineCycleNext<CR>", desc = "Move to next Buffer",   mode = "n" },
      { "<leader>bp", "<Cmd>BufferLineCyclePrev<CR>", desc = "Move to prev Buffer",   mode = "n" },
    },
  },

  -- ╔════════════════════════════════╗
  -- ║     PLUGIN: WHICH-KEY         ║
  -- ╚════════════════════════════════╝
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- ╔════════════════════════════════╗
  -- ║        PLUGIN: OIL            ║
  -- ╚════════════════════════════════╝
  {
    'stevearc/oil.nvim',
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      keymaps = {
        ["-"] = {
          desc = "Open oil floating window",
          callback = function()
            require("oil").open_float()
          end,
        },
        ["q"] = {
          desc = "Close floating window",
          callback = function()
            require("oil").close()
          end,
        },
        ["C-c"] = {
          desc = "Close float window if open",
          callback = function()
            require("oil").toggle_float()
          end,
        },
        ["C-h"] = {
          desc = "Toggle hidden files",
          callback = function()
            require("oil").toggle_hidden()
          end,
        },

      },
      float = {
        -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        max_width = 0.5,
        max_height = 0.5,
      },
    },
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },

  -- ╔════════════════════════════════╗
  -- ║     PLUGIN: TOGGLETERM         ║
  -- ╚════════════════════════════════╝
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      open_mapping = [[<C-/>]],
      direction = 'float',
    }
  },

  -- ╔════════════════════════════════╗
  -- ║       PLUGIN: FZF-LUA          ║
  -- ╚════════════════════════════════╝
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      local fzf_lua = require("fzf-lua")
      -- calling `setup` is optional for customization
      -- fzf_lua.setup({ "fzf-native" })
      fzf_lua.register_ui_select()

      vim.keymap.set("n", "<leader>sh", fzf_lua.helptags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sk", fzf_lua.keymaps, { desc = "[S]earch [K]eymaps" })
      vim.keymap.set("n", "<leader>sf", fzf_lua.files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>ss", fzf_lua.builtin, { desc = "[S]earch [S]elect Telescope" })
      vim.keymap.set("n", "<leader>sw", fzf_lua.grep_curbuf, { desc = "[S]earch grep [W]ord in buffer" })
      vim.keymap.set("n", "<leader>/", fzf_lua.lgrep_curbuf, { desc = "[S]earch Current Buffer" })
      vim.keymap.set("n", "<leader>sg", fzf_lua.live_grep_native, { desc = "[S]earch by [G]rep in current project" })
      vim.keymap.set("n", "<leader>q", fzf_lua.diagnostics_document, { desc = "Open diagnostic [Q]uickfix list" })
      vim.keymap.set("n", "<leader>sr", fzf_lua.resume, { desc = "[S]earch [R]esume" })
      vim.keymap.set("n", "<leader>s.", fzf_lua.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set("n", "<leader><leader>", fzf_lua.buffers, { desc = "[ ] Find existing buffers" })
      vim.keymap.set("n", "<leader>su", fzf_lua.spell_suggest, { desc = "[S]pell S[u]ggestions" })
      vim.keymap.set("n", "<leader>sp", fzf_lua.grep_project, { desc = "[S]earch [P]rojects" })

      vim.keymap.set("n", "<leader>sn", function()
        fzf_lua.files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[S]earch [N]eovim files" })
    end,
  },

  -- ╔════════════════════════════════╗
  -- ║     PLUGIN: LSPCONFIG         ║
  -- ╚════════════════════════════════╝
  {
    -- Mason must be loaded before its dependents so we need to set it up here.
    { "williamboman/mason.nvim", opts = {} },
    {
      "neovim/nvim-lspconfig",
      dependencies = { 'saghen/blink.cmp' } -- Allows extra capabilities provided by blink.cmp
    },
    opts = {}
  },

  -- ╔════════════════════════════════╗
  -- ║        PLUGIN: MINI           ║
  -- ╚════════════════════════════════╝
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      require("mini.animate").setup()

      require("mini.comment").setup()

      require("mini.notify").setup()
      -- require("mini.ai").setup({ n_lines = 500 })
      -- require("mini.surround").setup()

      require("mini.pairs").setup()

      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = vim.g.have_nerd_font, lazy = false })

      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return "%2l:%-2v"
      end

      require('mini.trailspace').setup()
    end,
  },

  -- ╔════════════════════════════════╗
  -- ║      PLUGIN: FLUTTER          ║
  -- ╚════════════════════════════════╝
  -- {
  --   "nvim-flutter/flutter-tools.nvim",
  --   ft = "dart",
  --   -- event = "VeryLazy",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   config = true,
  --   opts = {
  --     widget_guides = {
  --       enabled = true,
  --     },
  --     lsp = {
  --       colors = {
  --         enabled = true,
  --         background = true,
  --       },
  --     },
  --   },
  -- },

  -- ╔════════════════════════════════╗
  -- ║      PLUGIN: GITSIGNS         ║
  -- ╚════════════════════════════════╝
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "" },
        changedelete = { text = "~" },
        untracked = { text = "" },
      },
    },
    keys = {
      { "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "[T]oggle git [B]lame",        mode = "n" },
      { "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>",              desc = "Git [H]unk [P]review",        mode = "n" },
      { "<leader>hi", "<cmd>Gitsigns preview_hunk_inline<CR>",       desc = "Git [H]unk Preview [I]nline", mode = "n" },
      { "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>",                desc = "Git [H]unk [R]eset",          mode = "n" },
      { "<leader>hs", "<cmd>Gitsigns select_hunk<CR>",               desc = "Git [H]unk [S]elect",         mode = "n" },
      { "<leader>hn", "<cmd>Gitsigns next_hunk<CR>",                 desc = "Git [H]unk [N]ext",           mode = "n" },
    },
  },

  -- ╔════════════════════════════════╗
  -- ║      PLUGIN: NEO-TREE         ║
  -- ╚════════════════════════════════╝
  {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false,                    -- neo-tree will lazily load itself
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle Neo-tree" },
    },
  },


  -- ╔════════════════════════════════╗
  -- ║      PLUGIN: DIFFVIEW         ║
  -- ╚════════════════════════════════╝
  -- {
  --   "sindrets/diffview.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     view = {
  --       merge_tool = {
  --         layout = "diff3_mixed",
  --         disable_diagnostics = true,
  --       },
  --     },
  --   },
  -- },
}

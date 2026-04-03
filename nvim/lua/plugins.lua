return {
  -- ╔════════════════════════════════╗
  -- ║     PLUGIN: CATPPUCCIN        ║
  -- ╚════════════════════════════════╝

  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  -- ╔════════════════════════════════╗
  -- ║     PLUGIN: TREESITTER        ║
  -- ╚════════════════════════════════╝
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require("nvim-treesitter").setup()


      pcall(vim.treesitter.start)

      -- -- Treesitter needs a resolved filetype before it can infer the parser.
      -- vim.api.nvim_create_autocmd("FileType", {
      --   group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
      --   pattern = parsers,
      --   callback = function()
      --     pcall(vim.treesitter.start)
      --   end,
      -- })
    end,
  },

  -- ╔════════════════════════════════╗
  -- ║       PLUGIN: BLINK           ║
  -- ╚════════════════════════════════╝
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    event = "VeryLazy",
    version = "1.*",
    ---@module 'blink.cmp'
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
          ["<CR>"] = { "accept_and_enter", "fallback" },
        },
      },

      sources = {
        providers = {
          cmdline = {
            min_keyword_length = function(ctx)
              -- when typing a command, only show when the keyword is 3 characters or longer
              if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                return 3
              end
              return 0
            end,
          },
        },
      },
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
  },

  -- ╔════════════════════════════════╗
  -- ║     PLUGIN: WHICH-KEY         ║
  -- ╚════════════════════════════════╝
  {
    "folke/which-key.nvim",
    event = "VimEnter",
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
    icons = { mappings = vim.g.have_nerd_font },
  },

  -- ╔════════════════════════════════╗
  -- ║     PLUGIN: TOGGLETERM         ║
  -- ╚════════════════════════════════╝
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = [[<C-/>]],
      direction = "float",
    },
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
      vim.keymap.set(
        "n",
        "<leader>sg",
        fzf_lua.live_grep_native,
        { desc = "[S]earch by [G]rep in current project" }
      )
      -- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
      -- vim.keymap.set("n", "<leader>q", fzf_lua.diagnostics_document, { desc = "Open diagnostic [Q]uickfix list" })
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
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        -- "ty",
        "biome",
        "clangd",
        "gopls",
        "emmet_language_server",
        -- "ruff",
        "sqlls",
        -- "html",
        -- "cssls",
        "tailwindcss",
        -- "vtsls",
        "svelte",
        "zls",
        "lua_ls",
        "tsgo"
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      {
        "neovim/nvim-lspconfig",
        -- dependencies = { "saghen/blink.cmp" }, -- Allows extra capabilities provided by blink.cmp
      },
    },
  },

  -- ╔════════════════════════════════╗
  -- ║        PLUGIN: MINI           ║
  -- ╚════════════════════════════════╝
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      require("mini.animate").setup()


      require("mini.notify").setup()

      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = vim.g.have_nerd_font, lazy = false })

      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return "%2l:%-2v"
      end

      require("mini.trailspace").setup()
    end,
  },

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
      {
        "<leader>tb",
        "<cmd>Gitsigns toggle_current_line_blame<CR>",
        desc = "[T]oggle git [B]lame",
        mode = "n",
      },
      {
        "<leader>hp",
        "<cmd>Gitsigns preview_hunk<CR>",
        desc = "Git [H]unk [P]review",
        mode = "n",
      },
      {
        "<leader>hi",
        "<cmd>Gitsigns preview_hunk_inline<CR>",
        desc = "Git [H]unk Preview [I]nline",
        mode = "n",
      },
      {
        "<leader>hr",
        "<cmd>Gitsigns reset_hunk<CR>",
        desc = "Git [H]unk [R]eset",
        mode = "n",
      },
      {
        "<leader>hs",
        "<cmd>Gitsigns select_hunk<CR>",
        desc = "Git [H]unk [S]elect",
        mode = "n",
      },
      {
        "<leader>hn",
        "<cmd>Gitsigns next_hunk<CR>",
        desc = "Git [H]unk [N]ext",
        mode = "n",
      },
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

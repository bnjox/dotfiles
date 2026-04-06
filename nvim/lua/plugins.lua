vim.pack.add({
  {
    src = "https://github.com/catppuccin/nvim",
    name = "catppuccin",
    version = vim.version.range("*"),
  },
}, { load = true })

vim.cmd.colorscheme("catppuccin")

vim.pack.add({
  {
    src = "https://github.com/nvim-mini/mini.nvim",
    version = vim.version.range("*"),
  },
}, { load = true })

require("mini.trailspace").setup()
require("mini.notify").setup()
require("mini.animate").setup()

local statusline = require("mini.statusline")
statusline.setup({ use_icons = vim.g.have_nerd_font, lazy = false })

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return "%2l:%-2v"
end

vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
}, { load = true })

require("nvim-treesitter").setup()
pcall(vim.treesitter.start)

vim.pack.add({
  "https://github.com/rafamadriz/friendly-snippets",
  {
    src = "https://github.com/Saghen/blink.cmp",
    version = vim.version.range("1.*"),
  },
}, { load = true })

local blink = require("blink.cmp")
blink.setup({
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
          if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
            return 3
          end
          return 0
        end,
      },
    },
  },
})

local lsp_capabilities = blink.get_lsp_capabilities()

vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
}, { load = true })

vim.lsp.config("*", {
  capabilities = lsp_capabilities,
  root_markers = { ".git" },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      completion = { callSnippet = "Replace" },
      diagnostics = {
        globals = { "vim", "require" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("zls", {
  settings = {
    zls = { enable_build_on_save = true, semantic_tokens = "partial" },
  },
})

require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = {
    "biome",
    "clangd",
    "gopls",
    "emmet_language_server",
    "sqlls",
    "tailwindcss",
    "svelte",
    "zls",
    "lua_ls",
    "tsgo",
  },
})

vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/akinsho/bufferline.nvim",
}, { load = true })

require("bufferline").setup({
  options = {
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level)
      local icon = level:match("error") and " " or " "
      return " " .. icon .. count
    end,
  },
})

vim.pack.add({
  "https://github.com/folke/which-key.nvim",
}, { load = true })

local which_key = require("which-key")
which_key.setup({
  icons = { mappings = vim.g.have_nerd_font },
})

vim.keymap.set("n", "<leader>?", function()
  which_key.show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

vim.pack.add({
  "https://github.com/akinsho/toggleterm.nvim",
}, { load = true })

require("toggleterm").setup({
  open_mapping = [[<C-/>]],
  direction = "float",
})

vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/ibhagwan/fzf-lua",
}, { load = true })

local fzf_lua = require("fzf-lua")
fzf_lua.register_ui_select()

vim.keymap.set("n", "<leader>sh", fzf_lua.helptags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", fzf_lua.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", fzf_lua.files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>ss", fzf_lua.builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>sw", fzf_lua.grep_curbuf, { desc = "[S]earch grep [W]ord in buffer" })
vim.keymap.set("n", "<leader>/", fzf_lua.lgrep_curbuf, { desc = "[S]earch Current Buffer" })
vim.keymap.set("n", "<leader>sg", fzf_lua.live_grep_native, { desc = "[S]earch by [G]rep in current project" })
vim.keymap.set("n", "<leader>sr", fzf_lua.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", fzf_lua.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", fzf_lua.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>su", fzf_lua.spell_suggest, { desc = "[S]pell S[u]ggestions" })
vim.keymap.set("n", "<leader>sp", fzf_lua.grep_project, { desc = "[S]earch [P]rojects" })
vim.keymap.set("n", "<leader>sn", function()
  fzf_lua.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

vim.pack.add({
  "https://github.com/lewis6991/gitsigns.nvim",
}, { load = true })

require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "" },
    changedelete = { text = "~" },
    untracked = { text = "" },
  },
})

vim.keymap.set("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "[T]oggle git [B]lame" })
vim.keymap.set("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Git [H]unk [P]review" })
vim.keymap.set("n", "<leader>hi", "<cmd>Gitsigns preview_hunk_inline<CR>", { desc = "Git [H]unk Preview [I]nline" })
vim.keymap.set("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Git [H]unk [R]eset" })
vim.keymap.set("n", "<leader>hs", "<cmd>Gitsigns select_hunk<CR>", { desc = "Git [H]unk [S]elect" })
vim.keymap.set("n", "<leader>hn", "<cmd>Gitsigns next_hunk<CR>", { desc = "Git [H]unk [N]ext" })

vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-neo-tree/neo-tree.nvim",
}, { load = true })

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })

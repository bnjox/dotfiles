vim.pack.add({
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-tree/nvim-web-devicons",  -- dep for icons
  "https://github.com/rafamadriz/friendly-snippets", -- dep for blink
  "https://github.com/nvim-mini/mini.files",
  "https://github.com/nvim-mini/mini.statusline",
  "https://github.com/nvim-mini/mini.notify",
  {
    src = "https://github.com/Saghen/blink.cmp",
    version = vim.version.range("1.*"),
  },
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/neovim/nvim-lspconfig", -- deps for lspconfig
  "https://github.com/mason-org/mason.nvim",  -- deps for lspconfig
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/akinsho/toggleterm.nvim",
  -- "https://github.com/sindrets/diffview.nvim",
}, { load = true })

-- ╔════════════════════════════════╗
-- ║     PLUGIN: CATPPUCCIN         ║
-- ╚════════════════════════════════╝
vim.cmd.colorscheme("catppuccin")

-- ╔════════════════════════════════╗
-- ║     PLUGIN: TREESITTER         ║
-- ╚════════════════════════════════╝
require("nvim-treesitter").setup()

-- ╔════════════════════════════════╗
-- ║        PLUGIN: MINI            ║
-- ╚════════════════════════════════╝
require("mini.notify").setup()

local statusline = require("mini.statusline")
statusline.setup({ use_icons = vim.g.have_nerd_font, lazy = false })

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return "%2l:%-2v"
end

local minifiles = require("mini.files")
minifiles.setup({
  mappings = {
    go_in       = '', -- disabled (use Enter instead)
    go_in_plus  = '<CR>',
    go_out      = '<Left>',
    go_out_plus = '', -- disabled
  },
})

vim.keymap.set("n", "-", function()
  if not minifiles.close() then
    local buf_name = vim.api.nvim_buf_get_name(0)
    local path = buf_name == "" and vim.loop.cwd()
        or vim.fn.fnamemodify(buf_name, ":p:h")
    minifiles.open(path)
  end
end, { desc = "Toggle mini.files explorer" })


-- ╔════════════════════════════════╗
-- ║       PLUGIN: BLINK            ║
-- ╚════════════════════════════════╝
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
vim.lsp.config("*", {
  capabilities = lsp_capabilities,
  -- root_markers = { ".git" },
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

-- ╔════════════════════════════════╗
-- ║     PLUGIN: LSPCONFIG          ║
-- ╚════════════════════════════════╝
require("mason").setup()
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

-- ╔════════════════════════════════╗
-- ║     PLUGIN: BUFFERLINE         ║
-- ╚════════════════════════════════╝
-- require("bufferline").setup({
--   options = {
--     diagnostics = "nvim_lsp",
--     diagnostics_indicator = function(count, level)
--       local icon = level:match("error") and " " or " "
--       return " " .. icon .. count
--     end,
--   },
-- })

-- ╔════════════════════════════════╗
-- ║     PLUGIN: WHICH-KEY          ║
-- ╚════════════════════════════════╝
local which_key = require("which-key")
which_key.setup({
  -- icons = { mappings = vim.g.have_nerd_font },
})

vim.keymap.set("n", "<leader>?", function()
  which_key.show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

-- ╔════════════════════════════════╗
-- ║     PLUGIN: TOGGLETERM         ║
-- ╚════════════════════════════════╝
require("toggleterm").setup({
  open_mapping = [[<C-/>]],
  direction = "float",
})

-- ╔════════════════════════════════╗
-- ║       PLUGIN: FZF-LUA          ║
-- ╚════════════════════════════════╝
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
vim.keymap.set("n", "<leader>q", fzf_lua.diagnostics_document, { desc = "Open diagnostic [Q]uickfix list" })

-- ╔════════════════════════════════╗
-- ║      PLUGIN: GITSIGNS          ║
-- ╚════════════════════════════════╝
require("gitsigns").setup({
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
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


-- ╔════════════════════════════════╗
-- ║      PLUGIN: DIFFVIEW          ║
-- ╚════════════════════════════════╝
-- require("diffview").setup({
--   view = {
--     merge_tool = {
--       layout = "diff3_mixed",
--       disable_diagnostics = true,
--     },
--   },
-- })

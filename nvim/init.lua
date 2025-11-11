require("options")
require("keymaps")
require("autocmds")

-- See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  require("plugins"),
})

-- LSP servers and clients are able to communicate to each other what features they support.
--  By default, Neovim doesn't support everything that is in the LSP specification.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())
capabilities.textDocument.onTypeFormatting = { dynamicRegistration = false }

-- Set default for all clients
vim.lsp.config("*", {
  root_markers = { ".git" },
  capabilities = capabilities,
})
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },

      completion = { callSnippet = 'Replace' },
      -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      diagnostics = {
        globals = { "vim", "require" }, -- add both vim and require
        -- disable = { 'missing-fields' }
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME, -- include Neovim runtime
        },
      },
      telemetry = { enable = false },
    },
  }
})
vim.lsp.config("zls", {
  settings = {
    zls = { enable_build_on_save = true, semantic_tokens = "partial" }
  }
})

vim.lsp.enable({
  "basedpyright",
  "biome",
  "clangd",
  "gopls",
  "emmet_language_server",
  "prettierd",
  "ruff",
  "sqlls",
  "html",
  "cssls",
  "tailwindcss",
  "svelte",
  "vtsls",
  "zls",
  "lua_ls"
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

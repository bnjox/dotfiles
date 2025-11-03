-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Change indentation level to 4 for these languages
for _, extension in ipairs({ "go", "py", "zig" }) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = extension,
    command = "set tabstop=4 shiftwidth=4 softtabstop=4",
  })
end

-- Formatting with ZLS matches `zig fmt`.
-- The Zig FAQ answers some questions about `zig fmt`:
-- https://github.com/ziglang/zig/wiki/FAQ
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.zig", "*.zon" },
  callback = function()
    vim.lsp.buf.format()
    vim.lsp.buf.code_action({
      context = {
        only = {
          "source.fixAll",
          -- "source.organizeImports"
        },
        diagnostics = {}
      },
      apply = true,
    })
  end,
})

-- Create global autogroups once
local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = true })
local detach_augroup = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local bufnr = event.buf

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    end

    -----------------------------------------------------------
    -- Document highlights on CursorHold
    -----------------------------------------------------------
    if client and client:supports_method("textDocument/documentHighlight", bufnr) then
      -- Highlight references under cursor
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      -- Clear highlights on cursor move
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      -- Clear highlights when LSP detaches
      vim.api.nvim_create_autocmd("LspDetach", {
        group = detach_augroup,
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = highlight_augroup, buffer = event2.buf })
        end,
      })
    end

    -----------------------------------------------------------
    -- Inlay hints toggle keymap
    -----------------------------------------------------------
    if client and client:supports_method("textDocument/inlayHint", bufnr) then
      vim.keymap.set("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
      end, { desc = "[T]oggle Inlay [H]ints", buffer = bufnr })
    end
    --
  end,
})

-- Autoformat on save using only built-in LSP
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    local bufnr = args.buf
    local disable_filetypes = { c = false, cpp = true }

    if disable_filetypes[vim.bo[bufnr].filetype] then
      return
    end

    vim.lsp.buf.format({
      bufnr = bufnr,
      timeout_ms = 500,
      -- async = false, -- keep it sync so it finishes before saving
    })
  end,
})


-- Change diagnostic symbols in the sign column (gutter)
if vim.g.have_nerd_font then
  local signs = { ERROR = "", WARN = "", HINT = "", INFO = "" }
  local diagnostic_signs = {}
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    diagnostic_signs[vim.diagnostic.severity[type]] = icon
  end
  vim.diagnostic.config({ signs = { text = diagnostic_signs } })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("checktime", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(event)
    -- local exclude = { "gitcommit" } -- don't remember position in commit messages
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(event.buf)

    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})


-- Change indentation level to 4 for these languages
for _, extension in ipairs({ "go", "python", "zig" }) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = extension,
    command = "set tabstop=4 shiftwidth=4 softtabstop=4",
  })
end

-- Create global autogroups once
local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = true })
local detach_augroup = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local bufnr = event.buf

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method("textDocument/completion", { bufnr = bufnr }) then
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    end

    -----------------------------------------------------------
    -- Document highlights on CursorHold
    -----------------------------------------------------------
    if client and client:supports_method("textDocument/documentHighlight", { bufnr = bufnr }) then
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
    if client and client:supports_method("textDocument/inlayHint", { bufnr = bufnr }) then
      vim.keymap.set("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end, { desc = "[T]oggle Inlay [H]ints", buffer = bufnr })
    end
    --
  end,
})

-- Autoformat on save using only built-in LSP
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    local bufnr = args.buf
    local disable_filetypes = { c = false, cpp = true, }

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
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN]  = "",
        [vim.diagnostic.severity.HINT]  = "",
        [vim.diagnostic.severity.INFO]  = "",
      },
    },
  })
  -- local signs = { ERROR = "", WARN = "", HINT = "", INFO = "" }
  -- local diagnostic_signs = {}
  -- for type, icon in pairs(signs) do
  --   local hl = "DiagnosticSign" .. type
  --   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  --   diagnostic_signs[vim.diagnostic.severity[type]] = icon
  -- end
  -- vim.diagnostic.config({ signs = { text = diagnostic_signs } })
end

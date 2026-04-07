-- Treesitter needs a resolved filetype before it can infer the parser.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
  -- pattern = parsers,
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- update tree-sitter parsers whenever ‘nvim-treesitter’ is updated:
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end
})

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
    vim.hl.on_yank()
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "checkhealth",
    "gitsigns-blame",
    "help",
    "lspinfo",
    "notify",
    "qf",
    "startuptime",
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
    callback = function()
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.softtabstop = 4
    end,
  })
end

-- Create global autogroups once
local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = true })
local detach_augroup = vim.api.nvim_create_augroup("lsp-detach", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local bufnr = event.buf

    local client = vim.lsp.get_client_by_id(event.data.client_id)

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

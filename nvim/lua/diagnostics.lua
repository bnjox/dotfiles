--- Single source of truth for diagnostic UI.
--- Avoid calling vim.diagnostic.config() from options.lua, keymaps.lua, or autocmds.lua.

local palette = {
  err = "#51202A",
  warn = "#3B3B1B",
  info = "#1F3342",
  hint = "#1E2E1E",
}

local function set_highlights()
  vim.api.nvim_set_hl(0, "DiagnosticErrorLine", { bg = palette.err, blend = 20 })
  vim.api.nvim_set_hl(0, "DiagnosticWarnLine", { bg = palette.warn, blend = 15 })
  vim.api.nvim_set_hl(0, "DiagnosticInfoLine", { bg = palette.info, blend = 10 })
  vim.api.nvim_set_hl(0, "DiagnosticHintLine", { bg = palette.hint, blend = 10 })
  vim.api.nvim_set_hl(0, "DapBreakpointSign", { fg = "#FF0000", bg = nil, bold = true })
end

local function diagnostic_goto(next, level)
  local filter = level and vim.diagnostic.severity[level] or nil

  return function()
    vim.diagnostic.jump({ count = next and 1 or -1, severity = filter })
  end
end

set_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("diagnostic_highlights", { clear = true }),
  callback = set_highlights,
})

vim.fn.sign_define("DapBreakpoint", {
  text = "●",
  texthl = "DapBreakpointSign",
  linehl = "",
  numhl = "",
})

vim.diagnostic.config({
  virtual_text = true,   -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines
  -- underline = true,
  underline = { severity = vim.diagnostic.severity.ERROR },
  severity_sort = true,
  update_in_insert = false,
  float = {
    border = "rounded",
    source = true, -- 'if_many'
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = "",
      [vim.diagnostic.severity.HINT]  = "",
      [vim.diagnostic.severity.INFO]  = "",
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticErrorLine",
      [vim.diagnostic.severity.WARN] = "DiagnosticWarnLine",
      [vim.diagnostic.severity.INFO] = "DiagnosticInfoLine",
      [vim.diagnostic.severity.HINT] = "DiagnosticHintLine",
    },
  },
  -- virtual_text = {
  --   spacing = 4,
  --   source = "if_many",
  --   prefix = "●",
  -- },
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({
        bufnr = bufnr,
        scope = "cursor",
        focus = false,
      })
    end,
  },
})

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

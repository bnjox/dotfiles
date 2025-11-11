vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

vim.g.zig_fmt_autosave = 0     -- disable format on save from ziglang/zig.vim
vim.g.zig_fmt_parse_errors = 0 -- don't show parse errors in a separate window

-- disable netrw and unused built-in plugins at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_matchit = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_remote_plugins = 1

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"      -- Sync clipboard between OS and Neovim.
vim.opt.wrap = false                   -- Line wrap
-- vim.opt.linebreak = true               -- Wrap without breaking words
vim.opt.breakindent = true             -- Indent wrapped lines for readability
vim.opt.mouse = "a"                    -- Enable mouse mode!
vim.opt.ignorecase = true              -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.smartcase = true
vim.opt.tabstop = 2                    -- Insert spaces for tabs
vim.opt.shiftwidth = 2                 -- Number of spaces for each indent
vim.opt.expandtab = true               -- Convert tabs to spaces
vim.opt.softtabstop = 2                -- One tab equals 2 spaces, (amount of spaces a tab is)
vim.opt.smoothscroll = true
vim.opt.cursorline = true              -- Highlight the current line (default: false)
vim.opt.splitbelow = true              -- Force all horizontal splits to go below current window (default: false)
vim.opt.splitright = true              -- Force all vertical splits to go to the right of current window (default: false)
vim.opt.incsearch = true
vim.opt.showmode = false               -- We don't need to see things like -- INSERT -- anymore (default: true)
vim.opt.termguicolors = true           -- Set termguicolors to enable highlight groups (default: false)
-- vim.opt.whichwrap = 'bs<>[]hl' -- Which "horizontal" keys are allowed to travel to prev/next line (default: 'b,s')
vim.opt.numberwidth = 2                -- Set number column width to 2 {default 4} (default: 4)
vim.opt.swapfile = false               -- Creates a swapfile (default: true)
vim.opt.smartindent = true             -- Make indenting smarter again (default: false)
-- vim.opt.showtabline = 2 -- Always show tabs/buffertabs (default: 1)
vim.opt.backspace = "indent,eol,start" -- Allow backspace on (default: 'indent,eol,start')
-- vim.opt.pumheight = 10 -- Pop up menu height (default: 0)
vim.opt.conceallevel = 0               -- So that `` is visible in markdown files (default: 1)
vim.opt.signcolumn = "yes"             -- Keep signcolumn on by default (default: 'auto')
vim.opt.updatetime = 250               -- Decrease update time (default: 4000)
vim.opt.timeoutlen = 300               -- Time to wait for a mapped sequence to complete (in milliseconds) (default: 1000)
vim.opt.writebackup = false            -- If a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited (default: true)
vim.opt.undofile = true                -- Save undo history (default: false)
-- Set completeopt to have a better completion experience (default: 'menu,preview')
vim.opt.completeopt = "menu,menuone,noinsert"
-- vim.opt.shortmess:append 'c' -- Don't give |ins-completion-menu| messages (default: does not include 'c')
-- vim.opt.iskeyword:append '-' -- Hyphenated words recognized by searches (default: does not include '-')
-- vim.opt.formatoptions:remove { 'c', 'r', 'o' } -- Don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode. (default: 'croql')
vim.opt.inccommand = "split" -- Preview substitutions live, as you type!

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
  extends = "»",
  precedes = "«",
  leadmultispace = "···" .. string.rep("·", vim.o.shiftwidth - 1)
}
vim.opt.fillchars = { eob = "~", fold = " " }

vim.opt.foldmethod = "indent"
vim.opt.foldenable = false
vim.opt.foldlevel = 99
-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true
vim.diagnostic.config({ virtual_text = true })
vim.o.winborder = "rounded"
-- vim.opt.hidden = true -- Prevents the "No Write Since Last Change" warning when switching files.

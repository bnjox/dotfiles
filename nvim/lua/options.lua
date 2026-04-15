vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- vim.g.autoformat = true
-- vim.g.trouble_lualine = true

vim.g.have_nerd_font = true
vim.g.markdown_recommended_style = 0

vim.g.zig_fmt_autosave = 0     -- disable format on save from ziglang/zig.vim
vim.g.zig_fmt_parse_errors = 0 -- don't show parse errors in a separate window

-- disable netrw and unused built-in plugins at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- vim.g.loaded_matchparen = 1
-- vim.g.loaded_matchit = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
-- vim.g.loaded_remote_plugins = 1

-- ======= Indentation ========
vim.opt.tabstop = 2        -- Insert spaces for tabs
vim.opt.shiftwidth = 2     -- Number of spaces for each indent
vim.opt.softtabstop = 2    -- One tab equals 2 spaces, (amount of spaces a tab is)
vim.opt.expandtab = true   -- Convert tabs to spaces
vim.opt.smartindent = true -- Make indenting smarter again (default: false)
vim.opt.breakindent = true -- Indent wrapped lines for readability
vim.opt.wrap = false       -- Line wrap
vim.opt.numberwidth = 2    -- Set number column width to 2 {default 4} (default: 4)
vim.opt.shiftround = true  -- Round indent

-- ======= Search settings ========
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.smartcase = true  -- Case sensitive if uppercase in search
vim.opt.hlsearch = false  -- Don't highlight search results

-- ======= Visual settings ========
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true -- Set termguicolors to enable highlight groups (default: false)
vim.opt.signcolumn = "yes"   -- Keep signcolumn on by default (default: 'auto')
vim.opt.showmatch = true     -- Highlight matching brackets
vim.opt.matchtime = 2        -- How long to show matching bracket
vim.opt.cmdheight = 1        -- Keep a visible command line for package installs and other status output
vim.opt.showmode = false     -- We don't need to see things like -- INSERT -- anymore (default: true)
vim.opt.pumheight = 10       -- Popup menu height
vim.opt.pumblend = 10        -- Popup menu transparency
vim.opt.completeopt = "menu,menuone,noinsert"
vim.opt.confirm = true       -- Confirm to save changes before exiting modified buffer
vim.opt.inccommand = 'split' -- Preview substitutions live, as you type!
-- vim.opt.concealcursor = ""             -- Don't hide cursor line markup
-- opt.ruler = false                      -- Disable the default ruler
-- opt.virtualedit = "block"              -- Allow cursor to move where there is no text in visual block mode
-- opt.winminwidth = 5                    -- Minimum window width
vim.opt.showtabline = 2   -- always show tabs
vim.opt.cursorline = true -- Highlight the current line (default: false)
-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
  extends = "»",
  precedes = "«",
  leadmultispace = "···" .. string.rep("·", vim.o.shiftwidth - 1)
}
vim.opt.fillchars = {
  foldopen = "-",
  foldclose = "+",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = "~",
}

-- ======= File handling ========
vim.opt.writebackup = false -- Don't create backup before writing
vim.opt.swapfile = false    -- Creates a swapfile (default: true)
vim.opt.undofile = true     -- Save undo history (default: false)
vim.opt.updatetime = 250    -- Decrease update time (default: 4000)
vim.opt.timeoutlen = 300    -- Time to wait for a mapped sequence to complete (in milliseconds) (default: 1000)

-- ======= Behavior settings ========
vim.opt.iskeyword:append("-") -- Treat dash as part of word
vim.opt.path:append("**")     -- include subdirectories in search
vim.opt.mouse = "a"           -- Enable mouse mode!
vim.schedule(function() vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" end)

-- ======= Folding settings ========
vim.opt.smoothscroll = true
vim.opt.foldenable = true
vim.opt.foldlevel = 99             -- Start with all folds open
vim.opt.formatoptions = "jcroqlnt" -- tcqj

-- ======= Split behavior ========
vim.opt.splitbelow = true -- Force all horizontal splits to go below current window (default: false)
vim.opt.splitright = true -- Force all vertical splits to go to the right of current window (default: false)
vim.opt.splitkeep = "screen"

-- ======= Command-line completion ========
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- ======= Better diff options ========
vim.opt.diffopt:append("linematch:60")

-- ======= Performance improvements ========
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

-- ----------------------------------------------------------------


-- vim.opt.whichwrap = 'bs<>[]hl' -- Which "horizontal" keys are allowed to travel to prev/next line (default: 'b,s')
-- vim.opt.shortmess:append 'c' -- Don't give |ins-completion-menu| messages (default: does not include 'c')
-- vim.opt.formatoptions:remove { 'c', 'r', 'o' } -- Don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode. (default: 'croql')

vim.opt.winborder = "rounded"

vim.filetype.add({
  extension = {
    env = "dotenv",
  },
  filename = {
    [".env"] = "dotenv",
    ["env"] = "dotenv",
  },
  pattern = {
    ["[jt]sconfig.*.json"] = "jsonc",
    ["%.env%.[%w_.-]+"] = "dotenv",
  },
})

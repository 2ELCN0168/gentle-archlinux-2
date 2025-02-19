-- SYNTAX / COLOR
vim.cmd("syntax on")
vim.cmd("colorscheme retrobox")
vim.o.background = "dark"
vim.wo.cursorline = true

-- DETECT FILETYPE
vim.cmd("filetype plugin indent on")

-- ENABLE NUMBERS
vim.wo.number = true
vim.wo.relativenumber = true

-- FOLDING
vim.wo.foldmethod = "syntax"
vim.wo.foldlevelstart = 99

-- INDENT
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.tabstop = 8
vim.o.shiftwidth = 8
vim.o.softtabstop = 8

-- INVISIBLE CHARS
vim.o.list = true
vim.o.listchars = "tab:»·,trail:·,extends:#,nbsp:."

-- SMART SEARCH
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true

-- EASY NAVIGATION
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true })

-- STATUS BAR
vim.o.laststatus = 2
vim.o.ruler = true

-- BETTER WINDOW MANAGEMENT
vim.o.splitbelow = true
vim.o.splitright = true

-- COLUMN LIMIT
vim.wo.colorcolumn = "80"

-- SAVE
-- vim.o.backup = true
-- vim.o.backupdir = "~/.config/nvim/backup//"
-- vim.o.directory = "~/.config/nvim/swap//"
-- vim.o.undofile = true
-- vim.o.undodir = "~/.config/nvim/undo//"

-- COMMAND HISTORY
vim.o.history = 1000

-- SCROLLING
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

-- COPY/PASTE FROM SYSTEM CLIPBOARD
vim.o.clipboard = "unnamedplus"

-- AUTO FORMAT COMMENTS
vim.o.formatoptions = vim.o.formatoptions .. "cro"

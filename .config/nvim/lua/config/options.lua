-- Display line numbers
vim.opt.number = true

-- Indentation settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0   -- follow tabstop
vim.opt.softtabstop = -1 -- follow shiftwidth
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Search settings
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Automatically focus new splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Keep cursor above/below N lines
vim.opt.scrolloff = 12

-- Enable mouse usage
vim.opt.mouse = 'a'

-- Disable wrapping
vim.opt.wrap = false

-- Set terminal colors
vim.opt.termguicolors = true

-- Save undo history
vim.opt.undofile = true

-- Reserve a space in the gutter
vim.opt.signcolumn = "yes"

-- Hide the status line
vim.opt.cmdheight = 0

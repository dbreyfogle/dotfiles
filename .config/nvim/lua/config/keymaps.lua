-- Set leader
vim.g.mapleader = " "

-- System clipboard register
vim.keymap.set({ "n", "v" }, "<Leader>v", '"+', { desc = "System clipboard register"})

-- Keep paste buffer
vim.keymap.set("x", "<Leader>p", '"_dp', { desc = "Keep [P]aste buffer"})

-- Yank to end of line
vim.keymap.set("n", "Y", "y$")

-- Move lines
vim.keymap.set("n", "<M-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<M-k>", ":m .-2<CR>==")
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv")

-- Pane management
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", '<Leader>"', ":sp<CR>", { desc = "Split pane horizontally"})
vim.keymap.set("n", '<Leader>%', ":vsp<CR>", { desc = "Split pane vertically"})

-- Buffers
vim.keymap.set("n", "H", ":bp<CR>")
vim.keymap.set("n", "L", ":bn<CR>")
vim.keymap.set("n", "<Leader>x", ":bd<CR>", { desc = "Delete current buffer"})

-- Use absolute line numbers in insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		vim.opt.relativenumber = false
	end,
})

-- Use relative line numbers in normal mode
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		vim.opt.relativenumber = true
	end,
})

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

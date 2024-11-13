return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{ "williamboman/mason.nvim" },
		{ "jay-babu/mason-nvim-dap.nvim" },
		{ "nvim-neotest/nvim-nio" },
		{ "rcarriga/nvim-dap-ui" },
	},
	config = function()
		require("mason").setup({})
		require("mason-nvim-dap").setup({
			handlers = {}, -- sets up dap in the predefined manner
		})
		require("dapui").setup({})

		local dap = require("dap")

		vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint)
		vim.keymap.set("n", "<F5>", dap.continue)
		vim.keymap.set("n", "<F6>", require("dapui").toggle)
		vim.keymap.set("n", "<F10>", dap.step_over)
		vim.keymap.set("n", "<F11>", dap.step_into)
		vim.keymap.set("n", "<F12>", dap.step_out)

		-- Open windows automatically
		dap.listeners.before.attach.dapui_config = function()
			require("dapui").open()
		end
		dap.listeners.before.launch.dapui_config = function()
			require("dapui").open()
		end
	end,
}

return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			bash = { "shellcheck" },
			dockerfile = { "hadolint" },
			go = { "golangcilint" },
			markdown = { "markdownlint", "vale" },
			python = { "ruff", "mypy" },
			terraform = { "tflint" },
		}
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			callback = function()
				if vim.opt_local.modifiable:get() then
					lint.try_lint()
				end
			end,
		})
	end,
}

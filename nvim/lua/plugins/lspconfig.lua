return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "nvim-telescope/telescope.nvim" },
		{ "b0o/schemastore.nvim" },
	},
	config = function()
		local map = function(keys, func, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func)
		end
		map("gd", require("telescope.builtin").lsp_definitions)
		map("gi", require("telescope.builtin").lsp_implementations)
		map("go", require("telescope.builtin").lsp_type_definitions)
		map("gr", require("telescope.builtin").lsp_references)
		map("<C-k>", vim.lsp.buf.signature_help, { "i", "n" })
		map("<Leader>a", vim.lsp.buf.code_action)
		map("<Leader>r", vim.lsp.buf.rename)
		map("<C-j>", vim.diagnostic.open_float, { "i", "n" })
		map("]d", vim.diagnostic.goto_next)
		map("[d", vim.diagnostic.goto_prev)

		local lspconfig_defaults = require("lspconfig").util.default_config
		lspconfig_defaults.capabilities = vim.tbl_deep_extend(
			"force",
			lspconfig_defaults.capabilities,
			require("cmp_nvim_lsp").default_capabilities()
		)

		require("mason").setup({})
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
				["jsonls"] = function()
					require("lspconfig").jsonls.setup({
						settings = {
							json = {
								schemas = require("schemastore").json.schemas(),
								validate = { enable = true },
							},
						},
					})
				end,
				["yamlls"] = function()
					local schemas = require("schemastore").yaml.schemas()
					schemas["kubernetes"] = "*.yaml" -- default to k8s
					require("lspconfig").yamlls.setup({
						settings = {
							yaml = {
								schemas = schemas,
								schemaStore = { enable = false, url = "" },
							},
						},
					})
				end,
			},
		})

		-- Detect filetypes by pattern
		vim.filetype.add({
			pattern = {
				[".*/host_vars/.*%.ya?ml"] = "yaml.ansible",
				[".*/group_vars/.*%.ya?ml"] = "yaml.ansible",
				[".*/group_vars/.*/.*%.ya?ml"] = "yaml.ansible",
				[".*/.*playbook.*%.ya?ml"] = "yaml.ansible",
				[".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
				[".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
				[".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
				[".*/tasks/.*%.ya?ml"] = "yaml.ansible",
				[".*/molecule/.*%.ya?ml"] = "yaml.ansible",
			},
		})
	end,
}

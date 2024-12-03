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
					require("lspconfig").yamlls.setup({
						settings = {
							yaml = {
								schemas = require("schemastore").yaml.schemas(),
								schemaStore = { enable = false, url = "" },
							},
						},
						filetypes = table.insert(
							require("lspconfig").yamlls.document_config.default_config.filetypes,
							"yaml.kubernetes" -- custom handling for kubernetes files
						),
					})
				end,
			},
		})

		-- Detect filetypes by pattern
		vim.filetype.add({
			pattern = {
				[".*/templates/.*%.ya?ml"] = { "helm", { priority = 10 } },
				[".*/Chart%.ya?ml"] = { "helm", { priority = 10 } },
				[".*/values%.ya?ml"] = { "helm", { priority = 10 } },

				[".*/host_vars/.*%.ya?ml"] = "yaml.ansible",
				[".*/group_vars/.*%.ya?ml"] = "yaml.ansible",
				[".*/group_vars/.*/.*%.ya?ml"] = "yaml.ansible",
				[".*/.*playbook.*%.ya?ml"] = "yaml.ansible",
				[".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
				[".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
				[".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
				[".*/tasks/.*%.ya?ml"] = "yaml.ansible",
				[".*/molecule/.*%.ya?ml"] = "yaml.ansible",

				[".*/k8s/.*%.ya?ml"] = "yaml.kubernetes",
				[".*/kubernetes/.*%.ya?ml"] = "yaml.kubernetes",
				[".*/manifests/.*%.ya?ml"] = "yaml.kubernetes",
				[".*/base/.*%.ya?ml"] = "yaml.kubernetes",
				[".*/overlays/.*%.ya?ml"] = "yaml.kubernetes",
				[".*/deployments/.*%.ya?ml"] = "yaml.kubernetes",
				[".*/services/.*%.ya?ml"] = "yaml.kubernetes",
				[".*/.*deployment.*%.ya?ml"] = "yaml.kubernetes",
				[".*/.*service.*%.ya?ml"] = "yaml.kubernetes",
				[".*/.*configmap.*%.ya?ml"] = "yaml.kubernetes",
				[".*/.*secret.*%.ya?ml"] = "yaml.kubernetes",
				[".*/.*daemonset.*%.ya?ml"] = "yaml.kubernetes",
				[".*/.*ingress.*%.ya?ml"] = "yaml.kubernetes",
				[".*/.*statefulset.*%.ya?ml"] = "yaml.kubernetes",
			},
		})

		-- Apply kubernetes schema to custom yaml.kubernetes filetypes
		vim.api.nvim_create_autocmd({ "LspAttach", "FileType" }, {
			callback = function()
				if vim.bo.filetype == "yaml.kubernetes" then
					local client = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf(), name = "yamlls" })[1]
					if client then
						local set = {}
						if not client.config.settings.yaml.schemas["kubernetes"] then
							client.config.settings.yaml.schemas["kubernetes"] = {}
						else
							for _, name in ipairs(client.config.settings.yaml.schemas["kubernetes"]) do
								set[name] = true
							end
						end
						local buf_name = vim.api.nvim_buf_get_name(0)
						if not set[buf_name] then
							table.insert(client.config.settings.yaml.schemas["kubernetes"], buf_name)
							client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
						end
					end
				end
			end,
		})
	end,
}

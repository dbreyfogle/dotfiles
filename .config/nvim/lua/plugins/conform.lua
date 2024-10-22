return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      '<Leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      bash = { "shfmt" },
      json = { "prettier" },
      lua = { "stylua" },
      python = { "isort", "black" },
      terraform = { "terraform_fmt" },
      yaml = { "yamlfmt" },
    },
  },
}

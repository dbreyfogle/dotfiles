return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v4.x',
  dependencies = {
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'neovim/nvim-lspconfig' },
    { 'L3MON4D3/LuaSnip' },
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'rafamadriz/friendly-snippets' },
    { 'ray-x/lsp_signature.nvim' },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<Leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<Leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<Leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<Leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<Leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
      end,
    })

    local lspconfig_defaults = require('lspconfig').util.default_config
    lspconfig_defaults.capabilities = vim.tbl_deep_extend(
      'force',
      lspconfig_defaults.capabilities,
      require('cmp_nvim_lsp').default_capabilities()
    )

    require('mason').setup({})
    require('mason-lspconfig').setup({
      ensure_installed = {
        'bashls',
        'dockerls',
        'docker_compose_language_service',
        'jsonls',
        'lua_ls',
        'pyright',
        'terraformls',
        'yamlls',
      },
      handlers = {
        function(server_name)
          require('lspconfig')[server_name].setup({})
        end,
      }
    })

    local lsp_zero = require('lsp-zero')

    local cmp = require('cmp')
    local cmp_action = lsp_zero.cmp_action()

    require('luasnip.loaders.from_vscode').lazy_load()

    cmp.setup({
      sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'luasnip', keyword_length = 2 },
        { name = 'buffer',  keyword_length = 3 },
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
      }),
    })

    -- Automatically show signatures
    require('lsp_signature').setup({
      hint_enable = false,
    })
  end,
}

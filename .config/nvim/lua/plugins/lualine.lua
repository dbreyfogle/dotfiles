return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    local transparent_theme = require("lualine.themes.onedark")
    transparent_theme.normal.c.bg = "None"
    require("lualine").setup {
      options = {
        theme = transparent_theme,
        component_separators = "",
        section_separators = "",
      },
      extensions = { "neo-tree" }
    }
  end
}

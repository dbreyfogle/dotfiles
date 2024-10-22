return {
  "navarasu/onedark.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "dark"
  },
  config = function()
    vim.opt.background = "dark"
    vim.cmd.colorscheme("onedark")
  end,
}

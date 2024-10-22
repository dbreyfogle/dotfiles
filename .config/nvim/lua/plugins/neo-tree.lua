return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<Leader>e", ":Neotree toggle<CR>", desc = "Toggle [E]xplorer", silent = true },
  },
  opts = {
    window = {
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
        ["H"] = "", -- unbind
        ["<Leader>."] = "toggle_hidden",
      },
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      filtered_items = {
        visible = true,
        never_show = {
          ".DS_Store",
        }
      },
    },
  },
}

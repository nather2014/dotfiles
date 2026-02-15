return {
  -- Disable tokyonight
  { "folke/tokyonight.nvim", enabled = false },

  -- Use default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "default",
    },
  },

  -- Minimal statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "auto",
        component_separators = "",
        section_separators = "",
        icons_enabled = false,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
    },
  },
}

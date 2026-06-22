-- Colorscheme, statusline, icons, and general UI niceties.
return {
  {
    "aktersnurra/no-clown-fiesta.nvim",
    name = "no-clown-fiesta",
    lazy = false,
    priority = 1000,
    config = function()
      require("no-clown-fiesta").setup({
        transparent = false,
        styles = {
          -- Keep the look mono but let key syntax stand out a touch.
          functions = { bold = true },
          keywords = {},
          variables = {},
          type = { bold = true },
        },
      })
      vim.cmd.colorscheme("no-clown-fiesta")
    end,
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "diagnostics", "filetype" },
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = { scope = { enabled = true } },
  },

  -- Better vim.ui.select / input and notifications
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },
}

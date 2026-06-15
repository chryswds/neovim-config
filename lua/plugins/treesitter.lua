-- Syntax highlighting, indentation, and text objects via Tree-sitter.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- classic API used by the opts below (not the `main` rewrite)
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      -- Must track `master` to match nvim-treesitter above; the `main` branch is the
      -- incompatible rewrite and triggers `treesitter.lua: call method 'range' (nil)`.
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
    },
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "rust", "toml", "lua", "vim", "vimdoc", "query",
        "markdown", "markdown_inline", "json", "yaml", "bash", "regex",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          node_decremental = "<BS>",
          scope_incremental = "<TAB>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = { ["]f"] = "@function.outer" },
          goto_previous_start = { ["[f"] = "@function.outer" },
        },
      },
    },
  },
}

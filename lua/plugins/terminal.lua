-- A toggleable terminal: open it, run whatever you want, and hide it
-- (without killing the session) with the same key.
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>tt", desc = "Toggle terminal" },
    },
    opts = {
      -- Press this in normal OR terminal mode to open/hide the terminal.
      open_mapping = [[<leader>tt]],
      direction = "float",       -- a clean floating window, nothing else
      float_opts = { border = "curved" },
      start_in_insert = true,    -- drop straight into typing
      persist_mode = true,
      close_on_exit = true,      -- if the shell itself exits, close the window
      -- Buffer-local maps set up each time the terminal opens.
      on_open = function(term)
        -- In terminal-normal mode, `q` minimises (hides, keeps the session).
        vim.keymap.set("n", "q", "<cmd>ToggleTerm<CR>", {
          buffer = term.bufnr,
          desc = "Hide terminal",
        })
      end,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      -- Inside the terminal, Esc-Esc gets you back to normal mode so you can
      -- press `q` to hide it without sending keys to the shell.
      vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Terminal: normal mode" })
    end,
  },
}

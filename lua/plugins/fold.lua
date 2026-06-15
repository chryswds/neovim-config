return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    init = function()
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.foldcolumn = "1"
    end,
    opts = {
      provider_selector = function(_, _, buftype)
        -- Skip special buffers (neo-tree, trouble, etc.) to avoid UfoFallbackException
        if buftype ~= "" then return "" end
        return { "lsp", "treesitter" }
      end,
    },
    keys = {
      { "zR", function() require("ufo").openAllFolds() end,                   desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end,                  desc = "Close all folds" },
      { "zK", function() require("ufo").peekFoldedLinesUnderCursor() end,     desc = "Peek fold" },
    },
  },
}

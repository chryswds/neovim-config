-- Completion engine (blink.cmp) + snippets. Fast, Rust-friendly, minimal config.
return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "*", -- use a release tag so the prebuilt fuzzy matcher is downloaded
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "default", -- <C-y> confirm, <C-space> open, <C-n>/<C-p> select
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        -- auto_show off: showing docs per-item fires an LSP resolve on every
        -- arrow/Tab and makes navigation feel stuck. Use <C-space> to toggle docs.
        documentation = { auto_show = false },
        ghost_text = { enabled = false },
      },
      signature = { enabled = false },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    opts_extend = { "sources.default" },
  },
}

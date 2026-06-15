# Neovim — Rust config

Leader = `<Space>`. Plugin manager: **lazy.nvim** (`<leader>L`).

## Layout
```
init.lua                  -- entry point
lua/config/options.lua    -- editor settings + diagnostics
lua/config/keymaps.lua    -- general keymaps
lua/config/lazy.lua       -- plugin-manager bootstrap
lua/plugins/
  ui.lua                  -- tokyonight, lualine, which-key, indent guides
  editor.lua              -- telescope, neo-tree, gitsigns, trouble, comments
  treesitter.lua          -- syntax / textobjects (master branch)
  completion.lua          -- blink.cmp + snippets
  rust.lua                -- rustaceanvim, crates.nvim, mason, inlay hints
  dap.lua                 -- nvim-dap + dap-ui (codelldb)
  test.lua                -- neotest + rust adapter
```

## Rust workflow (`<leader>c…`, via rustaceanvim)
| Key | Action |
|-----|--------|
| `K` | Hover docs |
| `<leader>ch` | Hover **actions** (run/debug/apply) |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename |
| `<leader>cf` | Format buffer (rustfmt) |
| `<leader>ce` | Explain error (E####) |
| `<leader>cm` | Expand macro |
| `<leader>cc` | Open Cargo.toml |
| `<leader>cp` | Go to parent module |
| `<leader>ci` | Toggle inlay hints |
| `gd / gr / gi` | Definition / references / implementation |
| `]d / [d` | Next / prev diagnostic |

## Debug (`<leader>d…`)
`dd` pick a debuggable · `db` breakpoint · `dc` continue · `do/di/dO` step · `du` toggle UI.
First run installs **codelldb** via Mason automatically.

## Test (`<leader>t…`, neotest)
`tt` nearest · `tf` file · `tT` all · `tl` last · `td` debug nearest · `ts` summary
· `to` output · `tx` stop · `]t`/`[t` next/prev failed.

## Cargo.toml (`<leader>v…`, via crates.nvim)
`vt` toggle info · `vu/vU` update/upgrade crate · `va/vA` all · `vD` docs.rs.

## Find (`<leader>f…`, Telescope)
`ff` files · `fg` grep · `fb` buffers · `fe` file tree · `fs` symbols · `fr` resume.

## Git (`<leader>g…`) & Diagnostics
`gg` lazygit · `gf` lazygit (file history) · `gh` preview hunk · `gs` stage · `gb` blame
· `]h/[h` hunks · `<leader>xx` Trouble list.

## Notes
- `rust-analyzer` + `rustfmt` come from your rustup toolchain
  (`rustup component add rust-analyzer` if you ever reinstall).
- Diagnostics use **clippy** on save, not plain `cargo check`.
- Inlay hints are on by default — toggle with `<leader>ci`.
```

-- Rust toolchain integration: rustaceanvim drives rust-analyzer (no nvim-lspconfig
-- setup needed for Rust), crates.nvim manages Cargo.toml dependencies, and Mason
-- provides codelldb for debugging.

-- LSP keymaps applied whenever a language server attaches to a buffer.
local function on_attach(_, bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
  end

  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  map("n", "gr", "<cmd>Telescope lsp_references<CR>", "References")
  map("n", "gt", vim.lsp.buf.type_definition, "Type definition")
  map("n", "K", vim.lsp.buf.hover, "Hover docs")
  vim.keymap.set("n", "<leader>cr", function()
    return ":IncRename " .. vim.fn.expand("<cword>")
  end, { expr = true, buffer = bufnr, desc = "Rename symbol" })
  map("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")

  -- Rust-specific actions live under RustLsp; prefer them when available so we get
  -- grouped code actions, macro expansion, etc.
  map("n", "<leader>ca", function() vim.cmd.RustLsp("codeAction") end, "Code action (Rust)")
  map("n", "<leader>cd", function() vim.cmd.RustLsp({ "renderDiagnostic", "current" }) end, "Render diagnostic")
  map("n", "<leader>ce", function() vim.cmd.RustLsp("explainError") end, "Explain error")
  map("n", "<leader>cm", function() vim.cmd.RustLsp("expandMacro") end, "Expand macro")
  map("n", "<leader>cc", function() vim.cmd.RustLsp("openCargo") end, "Open Cargo.toml")
  map("n", "<leader>cp", function() vim.cmd.RustLsp("parentModule") end, "Go to parent module")
  map("n", "<leader>ck", function() vim.cmd.RustLsp({ "moveItem", "up" }) end, "Move item up")
  map("n", "<leader>cj", function() vim.cmd.RustLsp({ "moveItem", "down" }) end, "Move item down")
  -- Hover actions (apply, run, debug) instead of plain hover:
  map("n", "<leader>ch", function() vim.cmd.RustLsp({ "hover", "actions" }) end, "Hover actions")

  -- Run the program: pick a target (cargo run / a specific bin / example) or re-run the last.
  map("n", "<leader>rr", function() vim.cmd.RustLsp("runnables") end, "Run (pick target)")
  map("n", "<leader>rl", function() vim.cmd.RustLsp({ "runnables", bang = true }) end, "Run last target")
end

return {
  -- Mason: installer for codelldb (debug adapter). rust-analyzer and rustfmt come
  -- from your rustup toolchain, so we don't install them here.
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {},
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },

  -- The main event: rustaceanvim. No call to .setup() — configure via vim.g.
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false, -- the plugin lazy-loads itself on Rust files
    init = function()
      local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
      local codelldb_path, liblldb_path
      if mason_registry_ok then
        local ok, codelldb = pcall(mason_registry.get_package, mason_registry, "codelldb")
        if ok and codelldb:is_installed() then
          local ext = codelldb:get_install_path() .. "/extension"
          codelldb_path = ext .. "/adapter/codelldb"
          local ext_so = vim.fn.has("mac") == 1 and ".dylib" or ".so"
          liblldb_path = ext .. "/lldb/lib/liblldb" .. ext_so
        end
      end

      vim.g.rustaceanvim = {
        server = {
          on_attach = on_attach,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = { enable = true },
              },
              -- Use clippy instead of `cargo check` for richer diagnostics.
              checkOnSave = true,
              check = { command = "clippy", extraArgs = { "--no-deps" } },
              procMacro = { enable = true },
              inlayHints = {
                bindingModeHints = { enable = false },
                closureReturnTypeHints = { enable = "always" },
                lifetimeElisionHints = { enable = "skip_trivial", useParameterNames = true },
              },
            },
          },
        },
        dap = codelldb_path and {
          adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path),
        } or nil,
      }
    end,
  },

  -- Cargo.toml: dependency versions, features, upgrades.
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = { crates = { enabled = true } },
      lsp = { enabled = true, actions = true, completion = true, hover = true },
    },
    config = function(_, opts)
      require("crates").setup(opts)
      vim.api.nvim_create_autocmd("BufRead", {
        pattern = "Cargo.toml",
        callback = function(ev)
          local crates = require("crates")
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc, silent = true })
          end
          map("<leader>vt", crates.toggle, "Toggle crates info")
          map("<leader>vr", crates.reload, "Reload crates")
          map("<leader>vu", crates.update_crate, "Update crate")
          map("<leader>vU", crates.upgrade_crate, "Upgrade crate")
          map("<leader>va", crates.update_all_crates, "Update all crates")
          map("<leader>vA", crates.upgrade_all_crates, "Upgrade all crates")
          map("<leader>vH", crates.open_homepage, "Open homepage")
          map("<leader>vD", crates.open_documentation, "Open docs.rs")
        end,
      })
    end,
  },

  -- Toggle inlay hints globally with <leader>ci (handy when they get noisy).
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.keymap.set("n", "<leader>ci", function()
        local enabled = vim.lsp.inlay_hint.is_enabled()
        vim.lsp.inlay_hint.enable(not enabled)
      end, { desc = "Toggle inlay hints" })
      -- Enable inlay hints by default once an LSP attaches.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end
        end,
      })
    end,
  },
}

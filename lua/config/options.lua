-- Core editor options. Set leader before lazy loads so plugin mappings pick it up.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes" -- avoid layout shift when diagnostics appear
opt.cursorline = true
opt.termguicolors = true
opt.scrolloff = 8
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.showbreak = "↪ "
opt.splitright = true
opt.splitbelow = true
opt.colorcolumn = "100" -- rustfmt default max_width

-- Indentation (rustfmt uses 4 spaces; treesitter/LSP refine per-language)
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Files / undo
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- Responsiveness (good for LSP / diagnostics / CursorHold)
opt.updatetime = 250
opt.timeoutlen = 400

-- Completion / messages
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")

-- Diagnostics: inline virtual text + nicer signs
vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 2 },
  severity_sort = true,
  float = { border = "rounded", source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
})

-- System clipboard
opt.clipboard = "unnamedplus"

-- Suppress upstream plugin deprecation warnings that can't be fixed here.
-- rustaceanvim and nvim-lspconfig still call vim.lsp.get_buffers_by_client_id()
-- which Neovim 0.11 deprecated; remove once the plugins are patched.
local _orig_deprecate = vim.deprecate
vim.deprecate = function(name, ...)
  if name == "vim.lsp.get_buffers_by_client_id()" then return end
  return _orig_deprecate(name, ...)
end

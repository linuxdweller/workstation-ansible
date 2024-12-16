local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
vim.opt.rtp:prepend(lazypath)
require('lazy').setup('plugins')

-- Disable mouse mode.
vim.opt.mouse = ''

-- Display line numbers.
vim.opt.number = true

-- Persist undo trees.
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- Set tabs to display as 2 spaces.
vim.opt.tabstop = 2

-- Set keymap for LSP renaming.
vim.api.nvim_set_keymap('n', '<leader>rn', '', {noremap = true, callback = vim.lsp.buf.rename})

-- Prevent focusing on the hover popup.
-- See https://github.com/neovim/nvim-lspconfig/issues/1037
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  focusable = false,
  border = 'rounded'
})

-- Statusline
vim.api.nvim_set_hl(0, "StatusLine1", {bg="bg", fg="#8F99BC"})
vim.api.nvim_set_hl(0, "StatusLine2", {bg="bg", fg="#8F99BC"})
vim.api.nvim_set_hl(0, "StatusLine3", {bg="bg", fg="#5b6078"})
vim.opt.statusline = '%#StatusLine1#%f'
vim.opt.statusline:append("%#StatusLine2# %M %#normal#")
vim.opt.statusline:append("%=")
vim.opt.statusline:append("%#StatusLine3#%P %#StatusLine2#%l:%c")

-- Helm filetype detection
vim.filetype.add({
  pattern = {
    [".*/templates/.*%.ya?ml"] = "helm",
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.txt"] = "helm",
  },
})

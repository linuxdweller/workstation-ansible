require('plugins')

-- Use normal clipboard.
vim.opt.clipboard = 'unnamedplus'
-- Display line numbers.
vim.opt.number = true

vim.api.nvim_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', {noremap = true})

-- Show LSP hover when holding the cursor for 500ms.
vim.opt.updatetime = 500
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  -- Prevent focusing on the hover popup.
  -- See https://github.com/neovim/nvim-lspconfig/issues/1037
  focusable = false,
  border = "rounded"
})
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.lsp.buf.hover()
  end
})

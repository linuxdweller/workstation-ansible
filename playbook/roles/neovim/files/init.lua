require('plugins')

-- Disable mouse mode.
vim.opt.mouse = null

-- Use normal clipboard.
vim.opt.clipboard = 'unnamedplus'
-- Display line numbers.
vim.opt.number = true

-- Persist undo trees.
vim.opt.undofile = true
vim.opt.undolevels = 10000

vim.api.nvim_set_keymap('n', '<leader>rn', '', {noremap = true, callback = vim.lsp.buf.rename})

-- Show LSP hover when holding the cursor for 500ms.
vim.opt.updatetime = 500
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  -- Prevent focusing on the hover popup.
  -- See https://github.com/neovim/nvim-lspconfig/issues/1037
  focusable = false,
  border = 'rounded'
})
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    -- Only call hover() if any attached LSP client supports hover.
    clients = vim.lsp.buf_get_clients()
    for _, client in pairs(clients) do
      -- Ignore null-ls because it does not provide hover but is configured as if it does.
      if client.name ~= 'null-ls' and client.server_capabilities.hoverProvider then
        vim.lsp.buf.hover()
        return
      end
    end
  end
})

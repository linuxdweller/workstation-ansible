require('plugins')

-- Use normal clipboard.
vim.opt.clipboard = 'unnamedplus'
-- Display line numbers.
vim.opt.number = true

vim.api.nvim_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', {noremap = true})

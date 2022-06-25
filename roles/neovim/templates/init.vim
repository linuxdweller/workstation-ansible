lua require('plugins')

" Set theme.
colorscheme nightfox

lua <<EOF
-- Use normal clipboard.
vim.o.clipboard = 'unnamedplus'
-- Display line numbers.
vim.o.number = true

vim.api.nvim_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', {noremap = true})
EOF

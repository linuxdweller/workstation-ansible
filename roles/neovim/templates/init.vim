lua require('plugins')

" Basic settings:
" Use normal clipboard.
set clipboard+=unnamedplus
" Display line numbers.
set number

" Set theme.
colorscheme nightfox

set completeopt=menu,menuone,noselect

lua <<EOF
vim.api.nvim_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', {noremap = true})
EOF

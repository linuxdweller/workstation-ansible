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
-- Telescope setup.
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>", {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", {noremap = true})

vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd>lua require('telescope.builtin').command_history()<cr>", {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fc', "<cmd>lua require('telescope.builtin').commands()<cr>", {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fr', "<cmd>lua require('telescope.builtin').lsp_references()<cr>", {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fd', "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>", {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fi', "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>", {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fo', "<cmd>lua require('telescope.builtin').oldfiles()<cr>", {noremap = true})

vim.api.nvim_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', {noremap = true})
EOF

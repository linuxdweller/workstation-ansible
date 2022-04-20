lua require('plugins')

" Basic settings:
" Use normal clipboard.
set clipboard+=unnamedplus
" Display line numbers.
set number

" Set theme.
colorscheme nightfox

" Telescope setup.
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>

nnoremap <leader>fh <cmd>lua require('telescope.builtin').command_history()<cr>
nnoremap <leader>fc <cmd>lua require('telescope.builtin').commands()<cr>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').lsp_references()<cr>
nnoremap <leader>fd <cmd>lua require('telescope.builtin').lsp_definitions()<cr>
nnoremap <leader>fi <cmd>lua require('telescope.builtin').lsp_implementations()<cr>

set completeopt=menu,menuone,noselect

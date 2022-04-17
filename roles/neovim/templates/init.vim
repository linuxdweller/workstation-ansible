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
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

set completeopt=menu,menuone,noselect

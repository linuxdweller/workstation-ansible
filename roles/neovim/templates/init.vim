lua require('plugins')

" Basic settings:
" Use normal clipboard.
set clipboard+=unnamedplus
" Display line numbers.
set number
" Columns occupied by a tab.
set tabstop=2
set softtabstop=2
" Expand tabs to spaces.
set expandtab

" Set theme.
colorscheme nightfox

" Telescope setup.
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

set completeopt=menu,menuone,noselect

lua require('init')

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

set completeopt=menu,menuone,noselect

lua require('init')

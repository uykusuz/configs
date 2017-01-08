" a plugin to administrate plugins
execute pathogen#infect()

syntax on
set number
filetype plugin indent on

" show whitespaces
set listchars=tab:>-,trail:- " show tab in the form of ">---" and trailing whitespace as "-"
set list

" whitespaces
set expandtab " expand tab to spaces
set tabstop=4 "insert 4 spaces for a tab
set shiftwidth=4 "number of spaces when indenting

" make interaction more smooth
" helpful when using the mouse
set ttyfast

" enable mouse interaction
set mouse=a
set ttymouse=xterm2

" highlight current line
set cursorline

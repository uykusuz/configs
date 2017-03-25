set nocompatible

" ------------------------------------------------------------------------------
" --- Vundle setup ---
" ------------------------------------------------------------------------------
filetype off " required by Vundle

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'L9'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'derekwyatt/vim-fswitch'

call vundle#end()            " required
filetype plugin indent on    " required
" ------------------------------------------------------------------------------

syntax on
set number
filetype plugin indent on

" show whitespaces
set listchars=tab:>-,trail:- " show tab in the form of ">---" and trailing whitespace as "-"
set list

" enable switching buffers without having to save them
set hidden

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

" mark maximum number of characters per line
set colorcolumn=100
highlight ColorColumn ctermbg=DarkGray

" --------------------------
" --- keyboard shortcuts ---
" --------------------------
let mapleader=","

nmap <leader>m :CtrlPMRUFiles<CR>

nmap <F5> :YcmForceCompileAndDiagnostics<CR>
nmap <F6> :YcmDiags<CR>
nmap <leader>gt :YcmCompleter GoTo<CR>
nmap <leader>gi :YcmCompleter GoToImprecise<CR>
nmap <leader>gd :YcmCompleter GetDoc<CR>

nmap <leader>of :FSHere<CR>


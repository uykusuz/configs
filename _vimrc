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

" set default splitting positions to be more intuitive
set splitright
set splitbelow

" --------------------------
" --- keyboard shortcuts ---
" --------------------------
let mapleader=","

" close a buffer but leave the window open
" from http://stackoverflow.com/questions/1444322/how-can-i-close-a-buffer-without-closing-the-window#8585343
" doesn't work in every condition, but simple ones work
nmap <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

" CtrlP
nmap <leader>m :CtrlPMRUFiles<CR>

" YouCompleteMe
nmap <F5> :YcmForceCompileAndDiagnostics<CR>
nmap <F6> :YcmDiags<CR>
nmap <leader>gt :YcmCompleter GoTo<CR>
nmap <leader>gi :YcmCompleter GoToImprecise<CR>
nmap <leader>gd :YcmCompleter GetDoc<CR>

" FSwitch
nmap <leader>of :FSHere<CR>


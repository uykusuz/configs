set nocompatible

" ------------------------------------------------------------------------------
" --- Vundle setup ---
" ------------------------------------------------------------------------------
filetype off " required by Vundle

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" from vimscript
Plugin 'L9'

" from github
Plugin 'derekwyatt/vim-fswitch'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-scripts/grep.vim'

call vundle#end()            " required
filetype plugin indent on    " required
" ------------------------------------------------------------------------------

syntax on
set number
filetype plugin indent on

set noswapfile

" vertical scroll margin of 7 lines
set so=7

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

" highlight all search matches
set hlsearch

" --------------------------
" --- statusline ---
" --------------------------
set statusline=                 " clear statusline
set statusline+=[
set statusline+=%p%%            " percentage through file
set statusline+=\ %c            " column number
set statusline+=]
set statusline+=\ %f            " file name
set statusline+=%=              " separation for left/right items

" --------------------------
" --- keyboard shortcuts ---
" --------------------------
let mapleader=","

" close a buffer but leave the window open
" from http://stackoverflow.com/questions/1444322/how-can-i-close-a-buffer-without-closing-the-window#8585343
" doesn't work in every condition, but simple ones work
nmap <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

" search/replace visually selected text when hitting Ctrl-R in visual mode
vnoremap <C-r> y:%s/\<<C-r>0\>//g<left><left>

" CtrlP
nmap <leader>m :CtrlPMRUFiles<CR>
nmap <leader>b :CtrlPBuffer<CR>

" YouCompleteMe
nmap <F5> :YcmForceCompileAndDiagnostics<CR>
nmap <F6> :YcmDiags<CR>
nmap <leader>gt :YcmCompleter GoTo<CR>
nmap <leader>gi :YcmCompleter GoToImprecise<CR>
nmap <leader>gd :YcmCompleter GetDoc<CR>

" FSwitch
nmap <leader>of :FSHere<CR>

" NERDTree
nmap <leader>f :NERDTreeFind<CR>

" --------------------------
" --- YouCompleteMe ---
" --------------------------
let g:ycm_open_loclist_on_ycm_diags = 0
let g:ycm_enable_diagnostic_highlighting = 0


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
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-scripts/grep.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'fatih/vim-go'

call vundle#end()            " required
filetype plugin indent on    " required
" ------------------------------------------------------------------------------

syntax on
set number
filetype plugin indent on

colorscheme shine
highlight LineNr term=underline cterm=bold ctermfg=DarkYellow guifg=DarkYellow

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
if !has('nvim')
    set ttymouse=xterm2
endif

" highlight current line
set cursorline

" mark maximum number of characters per line
set colorcolumn=100
highlight ColorColumn ctermbg=DarkGray

" set default splitting positions to be more intuitive
set splitright
set splitbelow

" enable per-file settings
set modeline

" turn off beep for e.g. reaching end of file
set visualbell

" ----------------------------------
" --- Search ---
" ----------------------------------
set hlsearch                    " highlight all search matches
set ignorecase                  " ignore case by default
set smartcase                   " switch to case-sensitive if uppercase letter present

" ----------------------------------
" --- Filetype specific settings ---
" ----------------------------------
autocmd BufRead,BufNewFile *.yaml setlocal ts=2 sw=2

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

" NERDTree
nmap <leader>F :NERDTreeFind<CR>

" grep
nmap <leader>f :execute " grep -srnw --binary-files=without-match --exclude-dir=.git . -e " . expand("<cword>")<CR>

" move to left-most pane
nmap <leader>h :1winc w<CR>

" paste from system clipboards
nmap <leader>p "+p
nmap <leader>P "*p

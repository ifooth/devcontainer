set nocompatible
filetype off

let mapleader = ','
let g:mapleader = ','

syntax on

set number
"set cursorcolumn
"set cursorline


if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
endif

filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
set autoread

set background=dark
set t_Co=256

set laststatus=2
vnoremap <leader>y "+y

nnoremap <leader>sv :source $MYVIMRC<CR>

set history=2000

set expandtab
set tabstop=4
set shiftwidth=4
set smartindent

set wildignore=*.pyc,__pycache__

silent! so .vimlocal

inoremap kj <Esc>
"set lines=45 columns=150


set hlsearch
" 打开增量搜索模式,随着键入即时搜索
set incsearch
" 搜索时忽略大小写
set ignorecase
set scrolloff=7

set nowrapscan

set backspace=2
"set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P
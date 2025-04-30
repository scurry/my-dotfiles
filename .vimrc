set nocompatible
filetype off

" Set the leader key
let mapleader = ","

" Enable syntax highlighting
syntax on

" Set line numbers
set number

" Enable mouse support
set mouse=a

" Set tab width and use spaces instead of tabs
set tabstop=4
set shiftwidth=4
set expandtab

" Enable line wrapping
set wrap

" Highlight current line
set cursorline

" Set search options
set ignorecase
set smartcase
set incsearch

" Enable clipboard support
set clipboard=unnamedplus

" Plugin manager configuration (e.g., vim-plug)
call plug#begin('~/.vim/plugged')

" Add plugins here
" Example: Plug 'tpope/vim-sensible'

call plug#end()
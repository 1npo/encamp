" vim-plug
"
call plug#begin('~/.config/nvim/plugged')
Plug 'jceb/vim-orgmode'
Plug 'drewtempelmeyer/palenight'
Plug 'ayu-theme/ayu-vim'
Plug 'scrooloose/nerdtree'
Plug 'mhinz/vim-startify'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'arcticicestudio/nord-vim'
Plug 'chriskempson/base16-vim'
Plug 'dkarter/bullets.vim'
call plug#end()

" various settings
set encoding=UTF-8
set mouse=a
set nocompatible							" disable compatibility with vi
set showmatch								" show matching
set ignorecase								" case insensitive
set hlsearch								" hilight search
set incsearch								" incremental search
set number									" line numbers
set cursorline								" highlight current cursorline
set ttyfast									" speed up scrolling
set backupdir=~/.cache/nvim					" backup dir
set viminfo+=n~/.local/share/nvim/viminfo	" path to viminfo file
syntax on									" syntax highlighting

" tabs
set tabstop=4
set softtabstop=4 noexpandtab
set shiftwidth=4
autocmd FileType python setlocal tabstop=4

" indentation
set linebreak
set wrap
set nolist
set breakindent
let &showbreak='  '
set autoindent

" theme
set termguicolors
colorscheme base16-classic-dark
"let ayucolor="mirage"
let g:palenight_terminal_italics=1

" help from here:
" https://vi.stackexchange.com/questions/3359/how-do-i-fix-the-status-bar-symbols-in-the-airline-plugin
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" vim-plug
"
call plug#begin('~/.config/nvim/plugged')
Plug 'https://github.com/jceb/vim-orgmode.git'
Plug 'https://github.com/drewtempelmeyer/palenight.vim'
Plug 'https://github.com/ayu-theme/ayu-vim.git'
Plug 'scrooloose/nerdtree'
Plug 'mhinz/vim-startify'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
Plug 'dkarter/bullets.vim'
call plug#end()


" default pane resizing binds
"
" ctrl-w _		max out height of current pane
" ctrl-w |		max out width of current split
" ctrl-w =		normalize all split sizes
" ctrl-W T		break out current window into a new tabview


" better window splitting navigation
"
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


" open new split panes to right and bottom
"
set splitbelow
set splitright


" use utf-8
"
set encoding=UTF-8


" theme
"
set termguicolors
colorscheme base16-classic-dark 
"let ayucolor="mirage"
let g:palenight_terminal_italics=1


" syntax coloring
"
syntax on


" enable mouse support
"
set mouse=a


" sane tabs
"
set tabstop=4
set softtabstop=4 noexpandtab
set shiftwidth=4
autocmd FileType python setlocal tabstop=4


" put viminfo in ~/.vim instead of ~
"
set viminfo+=n~/.vim/viminfo


" use sane indentation when wrapping long lines in lists
"
set linebreak
set wrap
set nolist
set breakindent
let &showbreak='  '
set autoindent


" https://medium.com/geekculture/neovim-configuration-for-beginners-b2116dbbde84 
set nocompatible			" disable compatibility with vi
set showmatch				" show matching
set hlsearch				" hilight search
set incsearch				" incremental search
set number					" line numbers
set cursorline				" highlight current cursorline
set ttyfast					" speed up scrolling
set backupdir=~/.cache/nvim	" backup dir


" help from here:
" https://vi.stackexchange.com/questions/3359/how-do-i-fix-the-status-bar-symbols-in-the-airline-plugin

" Bullets.vim
let g:bullets_enabled_file_types = ['markdown']
" air-line
let g:airline_powerline_fonts = 1
let g:airline_theme = 'base16'
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

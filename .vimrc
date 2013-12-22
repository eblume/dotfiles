" Set up Pathogen
execute pathogen#infect()
syntax on
filetype plugin indent on

" Fix backspace indentation
set backspace=indent,eol,start

" Enable mouse everywhere
set mouse=a

" Hide mouse pointer while typing
set mousehide
set mousemodel=popup

" Code Folding, everything folded by default
set foldmethod=indent
set foldlevel=99
set foldenable

" Middle mouse click paste without formatting
map <MouseMiddle> <Esc>"*p

" Disable swapfiles, they don't seem to ever help
set noswapfile

" Set persistent undo (v7.3 only)
set undodir=~/.vim/undodir
set undofile

" Move backup files to ~/.vim/sessions
set backupdir=~/.vim/sessions
set dir=~/.vim/sessions

set background=dark
let g:solarized_termtrans=1
let g:solarized_termcolors=256
let g:solarized_contrast="high"
let g:solarized_visibility="high"
colorscheme solarized

" Syntax highlight syncing from the start
autocmd BufEnter * :syntax sync fromstart

" Set <Leader> to ',' and <localleader> to "\"
let mapleader=","
let maplocalleader="\\"

" Open files with command-t
noremap <leader>o <Esc>:CommandT<CR>
noremap <leader>O <Esc>:CommandTFlush<CR>
noremap <leader>m <Esc>:CommandTBuffer<CR>

" Take off the training wheels
noremap <up> <nop>
noremap <down> <nop>
nnoremap <up> <nop>
nnoremap <down> <nop>
vnoremap <up> <nop>
vnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>

" Enable automatic title setting for terminals
set title
set titleold="Terminal"
set titlestring=%F\ -\ Vim

" Activate a permanent ruler
set ruler

" Disable the blinking cursor
set gcr=a:blinkon0

" Every term I use is fast, sheesh
set ttyfast

" Go with smartindent if there is no plugin indent file.
set autoindent  smartindent
" but don't outdent hashes
inoremap # X#

" Global substitution regexes by default
set gdefault

" Better search
set hlsearch
set incsearch
set showmatch

" Hide matches on <leader>space
nnoremap <leader><space> :nohlsearch<cr>

" Remove trailing whitespace on <leader>S
nnoremap <leader>S :%s/\s\+$//<cr>:let @/=''<CR>

" <leader>v selects the just pasted text
nnoremap <leader>v V`]

" Copy/Paste to and from Desktop Environment
noremap <leader>yy "+y
noremap <leader>pp "+gP

" Make the command line two lines high and change the statusline display to
" something that looks useful.
set cmdheight=2
set laststatus=2
" set statusline=[%l,%v\ %P%M][CWD:\ %{CWD()}][FILE:\ %f]\ %r%h%w\ (%{&ff})\ %{fugitive#statusline()}\ %#warningmsg#%{SyntasticStatuslineFlag()}%*
set showcmd
set showmode
set number

" Tab Settings
set smarttab
set tabstop=4

" utf-8 default encoding
set enc=utf-8

" Prefer unix over windows over os9 formats
set fileformats=unix,dos,mac

" Keep more lines for scope
set scrolloff=5

" hide some files and remove stupid help
let g:netrw_list_hide='^\.,.\(pyc\|pyo\|o\)$'


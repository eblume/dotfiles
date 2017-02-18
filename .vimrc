" Set up Vundle
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

"""""""""""""""""""""""""
" NOTE TO SELF          "
" KEEP IT SIMPLE STUPID "
"""""""""""""""""""""""""

" nerdtree for a better file browser
Bundle 'scrooloose/nerdtree'
" pretty pretty
Bundle 'altercation/vim-colors-solarized'
" Kerboscript - syntax highlighting for kOS mod language for Kerbal Space Program
Plugin 'tomvanderlee/vim-kerboscript'
" Ruby linter
Plugin 'vim-ruby/vim-ruby', {'for': 'ruby'}    
" neomake
Plugin 'neomake/neomake'
" fzf file finder
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Auto-ctagging
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Always try to syntax highlight... I rarely write bare prose.
syntax on

" Enable 256 colors
set t_Co=256

" Fix backspace indentation
set backspace=indent,eol,start

" Disable bells... don't know why it's on anyway
set noerrorbells visualbell t_vb=
if has('autocmd')
    autocmd GUIEnter * set visualbell t_vb=
endif

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

" Take off the training wheels
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
vnoremap  <Up>     <NOP>
vnoremap  <Down>   <NOP>
vnoremap  <Left>   <NOP>
vnoremap  <Right>  <NOP>
nnoremap  <Up>     <NOP>
nnoremap  <Down>   <NOP>
nnoremap  <Left>   <NOP>
nnoremap  <Right>  <NOP>

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
set softtabstop=4
set shiftwidth=4
set tabstop=4
set expandtab

" utf-8 default encoding
set enc=utf-8

" Prefer unix over windows over os9 formats
set fileformats=unix,dos,mac

" Keep more lines for scope
set scrolloff=5

" hide some files and remove stupid help
let g:netrw_list_hide='^\.,.\(pyc\|pyo\|o\)$'

" Disable the help key entirely
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Make ; and : do the same thing
nnoremap ; :

" I version control everything, so save whenever vim loses focus
au FocusLost * :wa

" <leader>w opens a vertical split window and selects it.
nnoremap <leader>w <C-w>v<C-w>l

" Hold Ctrl and use hjkl to move through window panes
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" NERDTree will not keep vim from closing when closing a window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" NERDTree will change the CWD to the current node when changing the tree
" (ie, the root of the NERDTree will be the CWD at all times)
let g:NERDTreeChDirMode=2

" Map <leader>a to Ack
nnoremap <leader>a :Ack

" Automatically go fmt for golang files
autocmd FileType go autocmd BufWritePre <buffer> Fmt

" Use NERDTree in place of the default file browser
let NERDTreeHijackNetrw=1

" Tell NERDTree to please show hidden files, for fuck's sake
let NERDTreeShowHidden=1

" Open NERDTree with <Leader>-
nnoremap <leader>- :e .<CR>

" Use Ctrl-p to open fzf for finding files
nnoremap <C-p> :FZF<CR>

" Powerline setup
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

" Set up the column
set colorcolumn=90
 
" Ignore pyc files
set wildignore=*.pyc

" Don't add spaces when joining lines to avoid weird text errors.
" Might need to revisit this if non-prose joining gets wonky.
set nojoinspaces

" Change between NERDTree tabs with Shift+Arrow keys
nnoremap <S-Right> :tabn<CR>
nnoremap <S-Left>  :tabp<CR>

" YAML files need 2 space indentation
au FileType yaml setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2

" Ruby spacing
au FileType ruby setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2
au FileType eruby setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2

" JS spacing
au FileType javascript setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2

" NeoMake linter
let g:neomake_ruby_enabled_makers = ['rubocop']
autocmd! BufWritePost *.rb Neomake

" easytags
let g:easytags_async=1
let g:easytags_by_filetype='~/.easytags'
let g:easytags_auto_highlight=0

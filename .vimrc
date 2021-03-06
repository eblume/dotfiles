" Set up Vundle
set nocompatible              " be iMproved, required
filetype off                  " required
set shell=bash                " fix fish

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

" ctrlp for fast project searching
Bundle 'kien/ctrlp.vim'

" nerdtree for a better file browser
" Bundle 'scrooloose/nerdtree'
"
" pretty pretty
" Bundle 'altercation/vim-colors-solarized'
Plugin 'flazz/vim-colorschemes'

" FZF searching instead for ctrlp
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'

" Kerboscript - syntax highlighting for kOS mod language for Kerbal Space Program
" Plugin 'tomvanderlee/vim-kerboscript'

" Syntax support for 100+ languages
Bundle 'sheerun/vim-polyglot'

" Linting
Bundle 'vim-syntastic/syntastic'

" vim-airline
"Plugin 'vim-airline/vim-airline'

" vim-projector by Bailey ❤️
Plugin 'monokrome/vim-projector'

" Ag (via Ack)
Plugin 'mileszs/ack.vim'

" fugitive
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-rhubarb'

" pairs
" Bundle 'jiangmiao/auto-pairs'

" editorconfig
Plugin 'editorconfig/editorconfig-vim'

" unimpaired - Toggle Everything
Plugin 'tpope/vim-unimpaired'

" vim-vinegar, enhancements to netrw
Bundle 'tpope/vim-vinegar'

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


""""""""""""""" End of plugins stuff

" Always try to syntax highlight... I rarely write bare prose.
syntax on

" Enable 256 colors (let's try keeping this off for a while, see how we do)
" set t_Co=256

" Fix backspace indentation
" set backspace=indent,eol,start " temp disabling, just to see what's up

" Disable bells... don't know why it's on anyway
set noerrorbells visualbell t_vb=
if has('autocmd')
    autocmd GUIEnter * set visualbell t_vb=
endif

" Enable mouse everywhere
" set mouse=a (no, bad! stop using your mouse!)

" Hide mouse pointer while typing
set mousehide
set mousemodel=popup

" Code Folding, everything folded by default
set foldmethod=indent
set foldnestmax=0
set foldenable
" use space as the code folder
nnoremap <space> za
vnoremap <space> zf
" Note to check out
" https://stackoverflow.com/questions/357785/what-is-the-recommended-way-to-use-vim-folding-for-python-code
" in case there's some cool stuff there I missed. Specifically, code folding
" changing by file type.

" Middle mouse click paste without formatting
" map <MouseMiddle> <Esc>"*p
" temp disabled as I transition to linux: who knows what the clipboard story
" is now

" Disable swapfiles, they don't seem to ever help
set noswapfile

" Set persistent undo (v7.3 only)
set undodir=~/.vim/undodir
set undofile

" Move backup files to ~/.vim/sessions
set backupdir=~/.vim/sessions
set dir=~/.vim/sessions

"set background=dark
"let g:solarized_termtrans=1
"let g:solarized_termcolors=256
"let g:solarized_contrast="high"
"let g:solarized_visibility="high"
"colorscheme solarized


" CtrlP extension coolness stuff (uhoh)
let g:ctrlp_extensions = ['tag', 'mixed']
let g:ctrlp_cmd = 'CtrlPMixed'


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

" search highlight color
hi Search cterm=NONE ctermbg=LightYellow ctermfg=Red
hi Search guibg=LightYellow guifg=Red

" Other highlights
hi SpellBad cterm=None ctermbg=LightYellow ctermfg=Red
hi SpellCap cterm=None ctermbg=LightYellow ctermfg=Red

" Remove trailing whitespace on <leader>S
nnoremap <leader>S :%s/\s\+$//<cr>:let @/=''<CR>

" Copy/Paste to and from Desktop Environment
noremap <leader>yy "+y
noremap <leader>pp "+gP

" set cmdheight=2
set laststatus=2
" set statusline=[%l,%v\ %P%M][CWD:\ %{CWD()}][FILE:\ %f]\ %r%h%w\ (%{&ff})\ %{fugitive#statusline()}\ %#warningmsg#%{SyntasticStatuslineFlag()}%*
set showcmd
set showmode
set number

"""""""""" Tab Settings
" This is commented out because I think maybe it's causing tabbing issues
"
" set smarttab
set autoindent
"
" These are commented out so I can use per-language tabs, I hope.
"
" set softtabstop=4
" set shiftwidth=4
" set tabstop=4
set expandtab

" utf-8 default encoding
set enc=utf-8

" Prefer unix over windows over os9 formats
set fileformats=unix,dos,mac

" Keep more lines for scope
set scrolloff=5


" some netrw setup
let g:netrw_liststyle = 3  " tree view
let g:netrw_list_hide = '.\(pyc\|pyo\|o\)$' " hide some files and remove stupid help
let g:netrw_banner = 0

" Disable the help key entirely
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Make ; and : do the same thing
" nnoremap ; :  " why?!?

" <leader>[v,h] opens a [vertical/horizontal] split window and selects it.
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>h <C-w>h<C-w>l

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

" Automatically go fmt for golang files
autocmd FileType go autocmd BufWritePre <buffer> Fmt

" Use NERDTree in place of the default file browser
let NERDTreeHijackNetrw=1

" Tell NERDTree to please show hidden files, for fuck's sake
let NERDTreeShowHidden=1

" Open NERDTree with <Leader>-
nnoremap <leader>- :e .<CR>

" Set up the column
set colorcolumn=80
 
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

" JS files need 2 space indentation
au FileType javascript setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2

" RST files get 4 because it plays nice with python/doctest
au FileType rst setlocal tabstop=4 expandtab shiftwidth=4 softtabstop=4

" json
au FileType json setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2

" copy/paste in linux
set clipboard+=unnamed,unnamedplus

" Linting via Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Syntastic -- Javascript
let g:syntastic_javascript_checkers=['eslint']

" Syntastic -- Python
let g:syntastic_python_checkers=['flake8', 'python', 'mypy']

" Ack.vim - use Ag when able
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

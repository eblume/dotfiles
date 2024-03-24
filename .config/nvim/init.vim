" Load packer.nvim plugins (via .config/nvim/lua/plugins.lua)
lua require('plugins')

" Load lua init, which is where I do init.vim stuff but in lua
lua require("init")

" Automatically reload Packer config if it changed
augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end

" Set <Leader> to <Space> (ie, spacebar-leader)
" nnoremap <Space> <Nop>  " doesn't work 2023-04-19
let mapleader = "\<Space>"

" FZF search. More can be found here: https://github.com/junegunn/fzf.vim
nnoremap <leader>f :<C-u>Files<CR>
nnoremap <leader>t :<C-u>Tags<CR>
nnoremap <leader>b :<C-u>Buffers<CR>
nnoremap <leader>l :<C-u>Lines<CR>
if executable('rg')
  nnoremap <leader>a :<C-u>Rg<CR>
  nnoremap <leader>r :Rg <C-R><C-W><CR>
elseif executable('ag')
  nnoremap <leader>a :<C-u>Ag<CR>
  nnoremap <leader>r :Ag <C-R><C-W><CR>
endif
" Map ctrl-p to :Files, to mimic ctrlp.vim, which is burned in to my brain
" Disabled Mar 6 2024; it conflicts with zellij and its got leader-f, lets ditch it
" nnoremap <C-p> :<C-u>Files<CR>

" <leader>[v,h] opens a [vertical/horizontal] split window and selects it.
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>h <C-w>h<C-w>l

" Hide matches on <leader>/
nnoremap <leader>/ :nohlsearch<CR>

" some netrw setup
let g:netrw_liststyle = 3  " tree view
let g:netrw_banner = 0
let g:netrw_preview = 1  " press p to preview

" set wider column width
set textwidth=120
set formatoptions-=t  " Don't linewrap automatically while we are typing please
set formatoptions+=q  " but do allow gq to work
" set formatoptions-=c  " This disables automatic linewrap for comments.

" Don't add spaces when joining lines to avoid weird text errors.
" Might need to revisit this if non-prose joining gets wonky.
set nojoinspaces

" Ignore pyc files
set wildignore=*.pyc

" Windows, Mac, and Linux compatible copy/paste
" y/p works with C-c/C-v, and vice versa
set clipboard^=unnamed,unnamedplus

" Per default, netrw leaves unmodified buffers open. This autocommand
" deletes netrw's buffer once it's hidden (using ':q', for example)
autocmd FileType netrw setl bufhidden=delete

" Better search
set hlsearch
set incsearch
set showmatch

" Enable spellcheck for markdown files
autocmd FileType markdown,text setlocal spell

" make some things really visible
" use :set list / :set nolist to turn on and off
set listchars=eol:⏎,tab:␉·,trail:␠,nbsp:⎵

" line numbers
set number
set relativenumber

" Indentations / tabsttop
" NOTE on indentation: the defaults here effectively remove \t chars and
" replace with 2 spaces. If tabs are desired, either :set noexpandtab, or add
" a new section below with noexpandtab on, etc. See :help softtabstop for
" other options... there's lots of ways to do this, but this works well for me
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" 2 space indent, expandtab
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype ruby setlocal ts=2 sw=2 expandtab
autocmd Filetype lua setlocal ts=2 sw=2 expandtab

" 4 space indent, expandtab
" (not sure why I turned sts off, tbh)
autocmd Filetype sh setlocal ts=4 sw=4 sts=0 expandtab
autocmd FileType python setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype javascript setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype coffeescript setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype jade setlocal ts=4 sw=4 sts=0 expandtab

" colors and prettyness
set pumblend=15
let g:tokyonight_style="night"
" IMPORTANT: this colorscheme comes with assosciated terminal colors, found
" here: https://github.com/folke/tokyonight.nvim/tree/main/extras
colorscheme tokyonight

"Inactive window colors
let g:diminactive_use_colorcolumn = 0
let g:diminactive_use_syntax = 1
let g:diminactive_enable_focus = 1

" Terminal mode suggested remappings (via :help terminal-input)
:tnoremap <Esc> <C-\><C-n>  " bring back escape
:tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'  " ctrl-r for register pasting

" Window navigation in ANY mode. Uses alt instead of ctrl for compatibility with terminals.
:tnoremap <A-h> <C-\><C-N><C-w>h
:tnoremap <A-j> <C-\><C-N><C-w>j
:tnoremap <A-k> <C-\><C-N><C-w>k
:tnoremap <A-l> <C-\><C-N><C-w>l
:inoremap <A-h> <C-\><C-N><C-w>h
:inoremap <A-j> <C-\><C-N><C-w>j
:inoremap <A-k> <C-\><C-N><C-w>k
:inoremap <A-l> <C-\><C-N><C-w>l
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l

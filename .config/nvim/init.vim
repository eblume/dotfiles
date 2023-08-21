" Load packer.nvim plugins (via .config/nvim/lua/plugins.lua)
lua require('plugins')

" Load lua init, which is where I do init.vim stuff but in lua
lua require("init")

" Set vim-fubitive prefix for work bitbucket server
let g:fubitive_domain_pattern = 'bitbucket\.corp\.adcinternal\.com'

" Automatically reload Packer config if it changed
augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end

" Set <Leader> to <Space> (ie, spacebar-leader)
" nnoremap <Space> <Nop>  " doesn't work 2023-04-19
let mapleader = "\<Space>"

" Set vimwiki config
let g:vimwiki_list = [{'path': '~/code/personal/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_global_ext = 0  " Without this, all markdown files are treated as vimwiki files
"<S-CR> and <C-CR> don't work in terminals, apparently - fixes exist, but blech
nnoremap <leader>wv :VimwikiSplitLink<CR> 
" Crazy idea with gpt4-written code: vimwiki diary index autoregen
function! IsInVimwikiPath()
  let current_path = expand('%:p')  " Gets the full path of the current file
  " Here, loop over each of your vimwiki path
  for wiki_path in g:vimwiki_list
    " if your current file belongs to the vimwiki path, then return 1
    if stridx(current_path, expand(wiki_path.path)) == 0
      return 1
    endif
  endfor
  return 0
endfunction

augroup vimwiki_diary
  autocmd!
  autocmd BufEnter diary.md if IsInVimwikiPath() | call vimwiki#diary#generate_diary_section() | endif
augroup EN

" Still vimwiki - let's make a simple command to make a new heading entry
func! MyDiary()
    VimwikiMakeDiaryNote
    " If the buffer is empty, enter the day heading
    if line('$') == 1 && getline('$') == ''
        execute "normal! o# ".strftime('%B %d, %Y')
    endif
    execute "normal! G$o"
    execute "normal! o## ".strftime('%H:%M')
    execute "normal Go"
endfunc

command! MyDiary :call MyDiary()

" FZF search. More can be found here: https://github.com/junegunn/fzf.vim
nnoremap <leader>f :<C-u>Files<CR>
nnoremap <leader>t :<C-u>Tags<CR>
nnoremap <leader>b :<C-u>Buffers<CR>
nnoremap <leader>l :<C-u>Lines<CR>
if executable('rg')
  nnoremap <leader>a :<C-u>Rg<CR>
elseif executable('ag')
  nnoremap <leader>a :<C-u>Ag<CR>
endif
" Map ctrl-p to :Files, to mimic ctrlp.vim, which is burned in to my brain
nnoremap <C-p> :<C-u>Files<CR>

" <leader>[v,h] opens a [vertical/horizontal] split window and selects it.
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>h <C-w>h<C-w>l

" Hide matches on <leader>/
nnoremap <leader>/ :nohlsearch<CR>

" some netrw setup
let g:netrw_liststyle = 3  " tree view
let g:netrw_banner = 0

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

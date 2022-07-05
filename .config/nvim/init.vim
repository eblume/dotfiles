" Load packer.nvim plugins (via .config/nvim/lua/plugins.lua)
lua require('plugins')

" Load lua init, which is where I do init.vim stuff but in lua
lua require("init")

" Configure lualine
lua << EOD
  require('lualine').setup{
    options = {
      theme = 'tokyonight'
    }
  }
EOD

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

" Load packer.nvim plugins (via .config/nvim/lua/plugins.lua)
lua require('plugins')

" Configure lualine
lua << EOD
  require('lualine').setup()
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

" 4 space indent, expandtab
" (not sure why I turned sts off, tbh)
autocmd Filetype sh setlocal ts=4 sw=4 sts=0 expandtab
autocmd FileType python setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype javascript setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype coffeescript setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype jade setlocal ts=4 sw=4 sts=0 expandtab


" ALE (Linting/LSP)
" see :help ale-lint-file-linters
let g:ale_lint_on_insert_leave=1
let g:ale_lint_on_enter=1
let g:ale_lint_on_save=1
let g:ale_lint_on_filetype_changed=1
let g:ale_set_loclist=1
let g:ale_cursor_detail=1
" turn ale_close_preview_on_insert on if it's getting distracting
let g:ale_close_preview_on_insert=0
let g:ale_detail_to_floating_preview=1
let g:ale_lsp_show_message_severity='warning'
let g:ale_lsp_suggestions=1
let g:ale_use_global_executables=1
let g:ale_floating_preview=1
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
let g:ale_linters = {
\   'sh': ['language_server'],
\}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'sh': ['shfmt'],
\}
" Note: I disable cspell by default, because it's usually a disaster.
" If I want it back on, I should run in the buffer:
" :let b:ale_linters_ignore = []
" then, :edit
let g:ale_linters_ignore = ['cspell']
" use actionlint only on github action files (see
" https://github.com/dense-analysis/ale/blob/master/doc/ale-yaml.txt )
au BufRead,BufNewFile */.github/*/*.y{,a}ml let b:ale_linters = {'yaml': ['actionlint']}
" Uncomment the next line to turn off shellcheck and pyflakes, which might be
" faster? unclear
" let g:ale_yaml_actionlint_options = '-shellcheck= -pyflakes='
let g:ale_completion_symbols = {
\ 'text': '',
\ 'method': '',
\ 'function': '',
\ 'constructor': '',
\ 'field': '',
\ 'variable': '',
\ 'class': '',
\ 'interface': '',
\ 'module': '',
\ 'property': '',
\ 'unit': 'unit',
\ 'value': 'val',
\ 'enum': '',
\ 'keyword': 'keyword',
\ 'snippet': '',
\ 'color': 'color',
\ 'file': '',
\ 'reference': 'ref',
\ 'folder': '',
\ 'enum member': '',
\ 'constant': '',
\ 'struct': '',
\ 'event': 'event',
\ 'operator': '',
\ 'type_parameter': 'type param',
\ '<default>': 'v'
\ }

" ALE autocomplete (use ctrl-space)
let g:ale_completion_enabled=1
inoremap <silent> <C-Space> <C-\><C-O>:ALEComplete<CR>

" ale linter config
let g:ale_sh_bashate_options="--max-line-length=120"
let g:ale_sh_shfmt_options="-i 4"

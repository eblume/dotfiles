" Load packer.nvim plugins (via .config/nvim/lua/plugins.lua)
lua require('plugins')

" Configure lualine
lua << EOD
  require('lualine').setup()
EOD

" ALE (Linting/LSP)
" see :help ale-lint-file-linters
let g:ale_lint_on_insert_leave=1
let g:ale_lint_on_enter=1
let g:ale_lint_on_save=1
let g:ale_lint_on_filetype_changed=1
let g:ale_set_loclist=1


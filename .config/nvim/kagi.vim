" This function sets textwidth to 80 for markdown files under guides/**/
function! SetTextWidthForGuidesMarkdown()
    " Check if the file matches the pattern
    if expand('%:p') =~ 'guides/.*\.md$'
        " Set textwidth to 80
        setlocal textwidth=80
    endif
endfunction

" Use an autocommand to call the function on BufRead and BufNewFile events,
" which means whenever you open or create a markdown file
autocmd BufRead,BufNewFile *.md call SetTextWidthForGuidesMarkdown()

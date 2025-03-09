set -g ZK_PROJECT $ZK_DIR/payrix

if ! string match -r '^\d+$' $pageid
    echo >&2 "Unrecognized pageid format, expected an integer: $pageid"
    return 1
end
echo "Working on $pageid"
set -l page_note "$ZK_PROJECT/oncall/$pageid.md"

if ! test -e $page_note
    # Fill out a new template for the ticket's note
    set -l body "\
# $pageid
#alert #payrix #oncall

## Notes

"
    echo $body >$page_note
end

vim $page_note -c 'cd $ZK_PROJECT'

set -g ZK_PROJECT $ZK_DIR/payrix

set ticket (string upper $ticket) # abc-1234 -> ABC-1234

set -l ticket_note $ZK_DIR/tickets/$ticket
set -l jira "https://payrix.atlassian.net/browse/$ticket"

set -l in_zk "-c 'cd $ZK_DIR'"

# Check that the ticket is sane:
if ! string match -r '^\w+-\d+$' >/dev/null
    echo >&2 "Unrecognized ticket format, expected ABC-1234: $ticket"
    exit 1
end

if ! test -e $ticket_note
    # Fill out a new template for the ticket's note
    set -l body "\
# $ticket
#ticket #payrix

## Tasks
- [ ] Resolve [$ticket]($jira)

## Links
- [Payrix-Jira $ticket]($jira)
"

    ## TODO:
    #  - Automatically fill in ticket title, maybe body too?
    #  - Maybe ask an LLm to summarize?

    # Write the note to the store manually, then open in obsidian.nvim
    echo $body >$ticket_note
end

exec vim $ticket_note $in_zk

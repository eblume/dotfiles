function workon --description="Set $ZK_PROJECT='payrix' and open or create a note for the ticket." --argument-names=ticket
    set -g ZK_PROJECT $ZK_DIR/payrix

    if string match -r '^\w+-\d+$' $ticket
        set ticket (string upper $ticket) # abc-1234 -> ABC-1234
    else if string match -r '^https://payrix.atlassian.net/browse/(?<url_ticket>\w+-\d+)$' $ticket >/dev/null
        # Like: https://payrix.atlassian.net/browse/ABC-1234
        set ticket (string upper $url_ticket)
    else
        echo >&2 "Unrecognized ticket format, expected ABC-1234: $ticket"
        return 1
    end
    echo "Working on $ticket..."
    set -l ticket_note "$ZK_PROJECT/tasks/$ticket.md"
    set -l jira "https://payrix.atlassian.net/browse/$ticket"

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

    open $jira & # Open the ticket alongisde the ticket note
    vim $ticket_note -c 'cd $ZK_PROJECT'
end

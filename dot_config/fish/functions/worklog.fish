function worklog --description="Open worklog daily picker for payrix"
    set -g ZK_PROJECT $ZK_DIR/payrix
    vim -c "cd $ZK_PROJECT" -c 'Worklog'
end

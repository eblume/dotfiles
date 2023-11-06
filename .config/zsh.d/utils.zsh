# Various utility functions

function my_macname() {
  # Get or set the hostname of a Mac
  if [[ $# -eq 0 ]]; then
    echo "Usage: my_macname get | set NEW_NAME"
    return 1
  fi

  local action="$1"
  local new_name="$2"

  if [[ "${action}" == "get" ]]; then
    echo "ComputerName: $(scutil --get ComputerName 2>/dev/null)"
    echo "LocalHostName: $(scutil --get LocalHostName 2>/dev/null)"
    echo "HostName: $(scutil --get HostName 2>/dev/null)"
  elif [[ "${action}" == "set" ]]; then
    if [[ -z "${new_name}" ]]; then
      echo "Please provide a new name."
      return 1
    fi

    if ! [[ "${new_name}" =~ ^[a-zA-Z0-9-]+$ ]]; then
      echo "Invalid name. Name must contain only alphanumeric characters and hyphens."
      return 1
    fi

    sudo scutil --set ComputerName "${new_name}"
    sudo scutil --set LocalHostName "${new_name}"
    sudo scutil --set HostName "${new_name}"
    echo "All hostnames have been set to ${new_name}."
  else
    echo "Invalid action. Use 'get' or 'set'."
    return 1
  fi
}

function my_youtube() {
  # Open a YouTube link in Safari. To use, copy a YouTube link to the clipboard, then run this function.
  url="$1"

  if [ -z "$url" ]; then
      url="$(pbpaste)"
  fi

  if [[ "$url" =~ ^https?://(www\.)?(youtube\.com|youtu\.be)/ ]]; then
      echo "Opening YouTube link in Safari: $url"
      /usr/bin/open -a "Safari" "$url"
  else
      echo "Error: Invalid YouTube link. Please provide a valid YouTube link."
  fi
}

function my_branch() {
  # Use FZF to check out a branch by name, interactively
  git checkout $(git for-each-ref --format='%(refname:short)' refs/heads | fzf)
}

function my_cbwrap() {
  # Run a command and copy its output to the clipboard
  local tmpfile=$(mktemp)
  echo "$ $@" > $tmpfile
  eval "$@" | tee -a $tmpfile 2>&1;
  if command -v pbcopy > /dev/null; then
      cat $tmpfile | pbcopy
  elif command -v xclip > /dev/null; then
      cat $tmpfile | xclip -sel clip
  else
      echo "Neither pbcopy nor xclip is available."
      rm $tmpfile
      return 1
  fi
  rm $tmpfile
}

function my_llm() {
  if [ $# -eq 0 ]; then
    echo "No arguments provided. Launching $EDITOR for input."
    TEMPFILE=$(mktemp)
    if $EDITOR $TEMPFILE; then
        if [ -s $TEMPFILE ]; then
            echo "Running llm with input from $TEMPFILE"
            echo
            OPENAI_API_KEY="$(op item --vault personal get OpenAI --fields "API Key")" llm < $TEMPFILE
        else
            echo "No input detected in $TEMPFILE."
            echo "llm will not be run."
        fi
    else
        echo "Editor exited with error. llm will not be run."
    fi
    rm $TEMPFILE
  else
    OPENAI_API_KEY="$(op item --vault personal get OpenAI --fields "API Key")" llm $@
  fi
}

function my_idea() {
  # Use nb to add an idea entry
  if [ $# -eq 0 ]; then
    echo "Usage: my_idea IDEA"
    return 1
  fi
  idea="$@"
  nb --title "$idea" --type=idea.md --edit
  nb sync # (nbo 118)
}

function my_summarize() {
  # Example: my_summarize
  #   (default) Summarize last 5 updated entries
  # Example: my_summarize --type=log.md --sort --reverse
  #   Summarize last 5 log entries, sorted by creation order, most recent first
  #
  # NOTE: This works because nb overwrites arguments if specified multiple times

  files=$(nb list --type=md --limit=5 --no-id --filenames --paths $@ | grep -E "^/.*\.md$")
  if [ $? -ne 0 ]; then
    echo "Error: Could not load context."
    return 1
  fi

  context=$(cat << EOF
Name: Erich Blume
Date: $(date '+%Y-%m-%d')
Context:
$(xargs -L1 cat <<< "$files")
EOF
)

  my_llm -s "Please summarize my notebook, highlighting important pressing details. Aim for two to six bullet points." -o temperature 1.1 <<< "$context"
}

function my_logsum() {
  my_summarize --type=log.md --sort --reverse
}

function my_project {
  # With no args, list projects and their nb id's
  # With one arg, if it's numeric, open that nb doc, otherwise open the first matching search result of the arg string
  if [ $# -eq 0 ]; then
    nb list --type=project.md
  else
    if [[ "$1" =~ ^[0-9]+$ ]]; then
      nb edit "$1"
    else
      filename="$(nb list --type=project.md --limit=1 --no-id --paths "$*")"
      if [ $? -eq 0 ]; then
        nb edit "$filename"
      fi
    fi
  fi
}

function my_todo {
  # With no args, list the todos in the task list of todoist
  # Otherwise, args are stringified and used to make a new task in todoist
  TOKEN=$(op item --vault personal get Todoist --field 'API Key')
  if [ -z "$TOKEN" ]; then
    echo "Error: Could not get Todoist API Key from 1Password."
    return 1
  fi

  if [ $# -eq 0 ]; then
    FILTER="filter=(today | overdue) & !p3 & (p1 | (p2 & !#Work) | !(#Daily Routine | #Work Routine | #Chores | #Camano Chores | #Work))"
    curl -s --get https://api.todoist.com/rest/v2/tasks -H "Authorization: Bearer $TOKEN" --data-urlencode "$FILTER" | jq -r ".[].content"
  else
    JSON_DATA=$(printf '{"content": "%s", "due_string": "today"}' "$*")
    URL=$(curl -s -X POST https://api.todoist.com/rest/v2/tasks -H "Authorization: Bearer $TOKEN" -H "X-Request-Id: $(uuidgen)" -H "Content-Type: application/json" --data "$JSON_DATA" | jq -r ".url")
    echo "$(echo "$URL" | sed 's|https://todoist.com/showTask?|todoist://task?|')"
  fi
}

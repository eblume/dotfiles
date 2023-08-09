# Various utility functions

function my_macname() {
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

function my_llm() {
  OPENAI_API_KEY="$(op item get OpenAI --fields "API Key")" llm $@
}

function my_branch() {
  # Use FZF to check out a branch by name, interactively
  git checkout $(git for-each-ref --format='%(refname:short)' refs/heads | fzf)
}

my_cbwrap() {
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

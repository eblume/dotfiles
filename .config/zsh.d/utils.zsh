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
            OPENAI_API_KEY="$(op item get OpenAI --fields "API Key")" llm < $TEMPFILE
        else
            echo "No input detected in $TEMPFILE."
            echo "llm will not be run."
        fi
    else
        echo "Editor exited with error. llm will not be run."
    fi
    rm $TEMPFILE
  else
    OPENAI_API_KEY="$(op item get OpenAI --fields "API Key")" llm $@
  fi
}

function my_log() {
  # Use nb to add a diary entry. If it's the first entry of the day, use a full date line, otherwise use an abbreviated
  # one.
  long_form_date=$(date '+%A, %B %d, %Y')
  short_form_date=$(date '+%H:%M')
  calendar_date=$(date '+%Y-%m-%d')
  shortmsg=$'\n'"$@"
  edit=$(if [ $# -eq 0 ]; then echo "--edit"; else echo ""; fi)
  entries=$(nb list --type=log.md "${calendar_date}.log.md")
  if [ $? -eq 0 ]; then
    # entries WERE found, so use nb edit
    nb edit "${calendar_date}.log.md" --content "## ${short_form_date}${shortmsg}" $edit
  else
    # entries were NOT found, so use nb add
    nb add "${calendar_date}.log.md" --title "${long_form_date}" --content "## ${short_form_date}${shortmsg}" --type=log.md $edit
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

function my_transcribe() {
  # my_transcribe FILE
  # Transcribe an audio file to text using whisper.cpp
  # This function will, if needed, clone and build whisper.cpp and download a good model
  #
  # If ~/code/whisper.cpp does not exist, clone it
  codedir=~/code/3rd/whisper.cpp
  if [ ! -d $codedir ]; then
    git clone --quiet git@github.com:ggerganov/whisper.cpp.git $codedir
  fi
  cd $codedir

  git pull --quiet
  bash ./models/download-ggml-model.sh base.en > /dev/null 2>&1
  make > /dev/null 2>&1
  
  outfile="$(mktemp).wav"
  ffmpeg -i "$1" -ar 16000 -hide_banner -loglevel warning -nostats $outfile

  ./main -nt -f $outfile 2>/dev/null | grep -v '^$' | sed 's/^[ \t]*//'

  rm $outfile
  cd ~-
}

function my_vm() {
  # Batch process cloud-synced JustPressRecord voice memos
  # For each memo found, it will be transcribed and added to that day's log
  # If that day's log doesn't exist, it will be created
  # TODO: the voice memo should be archived (it is not currently)
  # The voice memo will then be deleted.
  # Thus, this function will ultimately move voice memos in to NB via transcription.

  # First, sync, because this is useless if its not synced
  nb sync
  
  clouddir="$HOME/Library/Mobile Documents/iCloud~com~openplanetsoftware~just-press-record/Documents"

  for file in $clouddir/*/*.m4a; do
    echo "Processing $file"
    date="$(basename "$(dirname "$file")")"
    thetime="$(date -j -f "%H-%M-%S" "$(basename "$file" | sed 's/\.m4a$//')" "+%H:%M")"
    longformat="+%A, %B %d, %Y"
    long_form_date=$(date -j -f "%Y-%m-%d" "$date" "$longformat")
    transcript=$'\n'$'\n'"$(my_transcribe "$file")"

    # TODO this UPSERT pattern is dumb, but also maybe backport it to my_log
    add_or_edit=$(if nb list --type=log.md "$date.log.md" > /dev/null 2>&1; then echo "edit"; else echo "add"; fi)
    
    nb $add_or_edit "$date.log.md" --title "$long_form_date" --type=log.md --content "## $thetime (Voice Memo)$transcript"

    # TODO archive
    rm "$file"
  done

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
      filename="$(nb list --type=project.md --limit=1 --no-id --paths "$@")"
      if [ $? -eq 0 ]; then
        nb edit "$filename"
      fi
    fi
  fi
}

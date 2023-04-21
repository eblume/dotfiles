#!/bin/zsh
# Defines `mymole` command to run mole with my API key.

function mymole() {
  if [ -z "$TODOIST_API_KEY" ]; then
    if [ -f ~/code/personal/.env_settings.sh ]; then
      source ~/code/personal/.env_settings.sh
    else
      echo "No API key found. Please set the TODOIST_API_KEY environment variable."
      exit 1
    fi
  fi

  ~/code/personal/mole/bin/mole
}

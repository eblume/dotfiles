#!/bin/zsh
# Defines mole commands to run mole with my API key.

function mymole {
  ~/code/personal/mole/bin/mole $@
}

function whack() {
  if [ -z "$TODOIST_API_KEY" ]; then
    if [ -f ~/code/personal/.env_settings.sh ]; then
      source ~/code/personal/.env_settings.sh
    else
      echo "No API key found. Please create ~/code/personal/.env_settings.sh"
      exit 1
    fi
  fi

  mymole whack
}


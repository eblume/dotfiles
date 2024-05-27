# Source homebrew based on our platform
if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  # WSL
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -f "/opt/homebrew/bin/brew" ]; then
  # mac os
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# It turns out that /usr/libexec/path_helper -s (invoked by /etc/zprofile) is doing weird things to PATH based on
# whether or not the user SSH'ed in or not. There's a billion posts about it, but the solution seems to be to just set
# the path ourselves. This is going to be a bit gross.
local newpath=":"

if [ -d "$HOME/.local/bin" ]; then
  newpath="$HOME/.local/bin:$newpath"
fi

# If HOMEBREW_PREFIX is set, which it should be from above, then we add a few things we might expect
# but for some reason don't always see
if [ ! -z "$HOMEBREW_PREFIX" ]; then
  if [ -d "$HOMEBREW_PREFIX/opt/postgresql@16/bin" ]; then
    newpath="$HOMEBREW_PREFIX/opt/postgresql@16/bin:$newpath"
  fi

  if [ -d "$HOMEBREW_PREFIX/opt/sqlite/bin" ]; then
    newpath="$HOMEBREW_PREFIX/opt/sqlite/bin:$newpath"
  fi

  if [ -d "$HOMEBREW_PREFIX/opt/fzf/bin" ]; then
    newpath="$HOMEBREW_PREFIX/opt/fzf/bin:$newpath"
  fi

fi

# if newpath is no longer just ":", export it in front of PATH
if [ "$newpath" != ":" ]; then
  export PATH="$newpath$PATH"
fi

# Set a consistent TMPDIR, mostly for ssh-agent AUTH_SOCK locations.
export TMPDIR="$HOME/tmp"
mkdir -p "$TMPDIR"

# Also, unfortunately, we can't trust apple's launchd ssh-agent listener because it doesn't get set in SSH! I would LOVE
# to use it, but I need a consistent SSH_AUTH_SOCK to get services working properly. So we detect com.apple.launchd in
# SSH_AUTH_SOCK and if set, we unset it and set our own.
function () {
  if [ ! -z "$SSH_AUTH_SOCK" ]; then
    if [[ "$SSH_AUTH_SOCK" != *"com.apple.launchd"* ]]; then
      # Happy path - good agent detected
      return
    fi
  fi

  local agents=$(find $TMPDIR -type s -name "agent.*" 2>/dev/null)
  if [ -z "$agents" ]; then
    # No agent found, start a new one
    eval $(ssh-agent -s)
    return
  fi

  # kludge: we sort the agents by name and take the first. Order doesn't matter so long as its stable.
  local agent=$(echo $agents | tr ' ' '\n' | sort -r | head -n 1)
  export SSH_AUTH_SOCK="$agent"
  # We don't need to export SSH_AGENT_PID because we're not using it.
}

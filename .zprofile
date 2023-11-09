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

if [ -d "$HOME/.asdf/shims" ]; then
  newpath="$HOME/.asdf/shims:$newpath"
fi

# If HOMEBREW_PREFIX is set, which it should be from above, then we add a few things we might expect
# but for some reason don't always see
if [ ! -z "$HOMEBREW_PREFIX" ]; then
  if [ -d "$HOMEBREW_PREFIX/opt/postgresql@16/bin" ]; then
    newpath="$HOMEBREW_PREFIX/opt/postgresql@16/bin:$newpath"
  fi

  if [ -d "$HOMEBREW_PREFIX/opt/asdf/libexec/bin" ]; then
    newpath="$HOMEBREW_PREFIX/opt/asdf/libexec/bin:$newpath"
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

# Also, unfortunately, we can't trust apple's launchd ssh-agent listener because it doesn't get set in SSH! I would LOVE
# to use it, but I need a consistent SSH_AUTH_SOCK to get services working properly. So we detect com.apple.launchd in
# SSH_AUTH_SOCK and if set, we unset it and set our own.

if [ ! -z "$SSH_AUTH_SOCK" ]; then
  if [[ "$SSH_AUTH_SOCK" == *"com.apple.launchd"* ]]; then
    echo "Unsetting SSH_AUTH_SOCK because it's set to $SSH_AUTH_SOCK"
    echo "(And we can't trust apple's launchd ssh-agent listener)"
    unset SSH_AUTH_SOCK
    eval $(ssh-agent -s)
  fi
else
  eval $(ssh-agent -s)
fi

# Finally, as another sanity check, we create a new TMPDIR. For some reason, SOMETHING is setting TMPDIR in local
# sessions but not in SSH sessions, probably related to the path_helper issue above.
export TMPDIR="$HOME/tmp"
mkdir -p "$TMPDIR"

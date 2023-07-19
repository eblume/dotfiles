# Source homebrew based on our platform
if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  # WSL
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -f "/opt/homebrew/bin/brew" ]; then
  # mac os
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Created by `pipx` on 2023-07-19 01:33:08
# (Didn't I do this already?! Trouble is brewing.)
export PATH="$PATH:$HOME/.local/bin"

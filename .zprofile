# Source homebrew based on our platform
if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  # WSL
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -f "/opt/homebrew/bin/brew" ]; then
  # mac os
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

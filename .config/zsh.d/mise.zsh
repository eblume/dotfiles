# Load mise (mise-en-place), a package manager like asdf, pipx, npm, go, etc.


if ! command -v brew &> /dev/null; then
  echo 2>&1 "mise: brew is not installed. Please install Homebrew first."
  echo 2>&1 "Have you run the 'yadm bootstrap' command yet?"
elif ! brew list mise &> /dev/null; then
  echo 2>&1 "mise: mise is not installed. Please install via homebrew (or other)."
  echo 2>&1 "Have you run the 'yadm bootstrap' command yet?"
else
  eval "$("$(brew --prefix mise)"/bin/mise activate zsh)"
fi


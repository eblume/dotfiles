# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"

# Default Command
# ---------------
if command -v bfs &> /dev/null; then
  export FZF_DEFAULT_COMMAND="bfs -type f"
elif command -v rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git/*'"
fi

if command -v eza &> /dev/null; then
  export FZF_DEFAULT_OPTS='--exit-0 --ansi --preview="eza -l {}" --preview-window=down,20% --bind="pgup:preview-half-page-up" --bind="pgdn:preview-half-page-down"'
fi

# This might cause some problems someday, see:
# https://github.com/junegunn/fzf?tab=readme-ov-file#environment-variables
if [[ -z "$FZF_CTRL_T_COMMAND" ]]; then
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

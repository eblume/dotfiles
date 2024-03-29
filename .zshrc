# ~/.zshrc
# My personal setup for zsh, which is managed by yadm (https://yadm.io/)
#
# 
# 
# ~/.zprofile, which preceeds this file in most login shells, is intended as a place for creating relatively consistent
# environment variables across shell types. (It does not succeed, but it tries, and we love it for that.)
#
# This file in contrast is about taking a consistent environment and building up my tools and aliases on top of it.

# Enable homebrew completions
if type brew &>/dev/null
then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    # Note, we will compinit later on
else
    echo "WARNING: brew not found, have you set up homebrew yet? The remaing config is likely to fail..."
    echo "Try: https://brew.sh/"
fi

# Enable sqlite3 managed by homebrew
if type brew &>/dev/null
then
    # Check if sqlite is installed
    if brew ls --versions sqlite > /dev/null
    then
        export PATH="$(brew --prefix sqlite)/bin:$PATH"
    else
        echo "WARNING: SQLite not found, have you installed it using brew yet? (Defaulting to system sqlite...)"
    fi
else
    echo "WARNING: brew not found, have you set up homebrew yet? The remaing config is likely to fail..."
fi

# Activate z (jump around!)
Z_ACTIVATION_SCRIPT="$(brew --prefix)"/etc/profile.d/z.sh
if [[ -f "$Z_ACTIVATION_SCRIPT" ]]
then
    . $Z_ACTIVATION_SCRIPT
else
    echo "WARNING: z.sh not found, have you run yadm bootstrap yet? (Skipping z.sh...)"
fi

YADM_MODIFIED_FILES="$(yadm diff --name-only; yadm diff --name-only --staged; )"
if [ ! -z "${YADM_MODIFIED_FILES// }" ]
then
    echo "NOTICE: There are uncommited modified config files. See 'yadm status'."
    echo $YADM_MODIFIED_FILES
fi

### Enable starship prompt
eval "$(starship init zsh)"

### Load extra configs (managed by me)
for file in ~/.config/zsh.d/*; do
    # Check suffix ends in .zsh
    if [[ "$file" != *.zsh ]]; then
        continue
    fi
    source "$file"
done

### Load custom zfuncs (managed by me) (eg for completions)
fpath=(~/.zfunc $fpath)
autoload -Uz compinit
compinit

### Helpful aliases 'n such
alias vim="nvim"
export EDITOR="$(which nvim)"
alias jq="jaq"

# Misc
export GPG_TTY=$(tty)  # needed for yadm encrypt (via gpg)
alias nbo="nb o"  # open notebook

# Enable shared history, WHY IN 2022 IS THIS NOT DEFAULT
setopt inc_append_history
setopt share_history
export SAVEHIST=10000000
export HISTSIZE=10000000

# Created by `pipx` on 2023-07-19 01:33:08
export PATH="$PATH:$HOME/.local/bin"

# Unset TMPDIR if it's set
# This hack is needed because otherwise zellij sessions wind up in different places depending on the way the session
# started.
# I haven't figured this one out yet, but the net result is that if you ssh to ringtail TMPDIR is unset and otherwise
# it's set. Really would love to know what is setting TMPDIR this way.
#if [ ! -z "$TMPDIR" ]; then
#    unset TMPDIR
#fi

# Enable ssh-agent early if its not running
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval "$(ssh-agent -s)"
fi

# Enable homebrew completions
if type brew &>/dev/null
then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    # Note, we will compinit later on
else
    echo "WARNING: brew not found, have you set up homebrew yet? The remaing config is likely to fail..."
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

# Activate asdf
ASDF_ACTIVATION_SCRIPT="$(brew --prefix asdf)"/libexec/asdf.sh
if [[ -f "$ASDF_ACTIVATION_SCRIPT" ]]
then
    . $ASDF_ACTIVATION_SCRIPT
else
    echo "WARNING: asdf not found, have you set up yadm yet? (Skipping asdf setup...)"
fi

# Activate z (jump around!)
Z_ACTIVATION_SCRIPT="$(brew --prefix)"/etc/profile.d/z.sh
if [[ -f "$Z_ACTIVATION_SCRIPT" ]]
then
    . $Z_ACTIVATION_SCRIPT
else
    echo "WARNING: z.sh not found, have you run yadm bootstrap yet? (Skipping z.sh...)"
fi

# Activate my work config
WORK_CONFIG_FILE="$HOME/code/work/config.zsh"
if [[ -f "$WORK_CONFIG_FILE" ]]
then
    . $WORK_CONFIG_FILE
fi

# Load postgresql16 bin if installed
if [ -d "/usr/local/opt/postgresql@16/bin" ]
then
    export PATH="/usr/local/opt/postgresql@16/bin:$PATH"
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

# Misc
export GPG_TTY=$(tty)  # needed for yadm encrypt (via gpg)
alias nbo="nb o"  # open notebook

# Enable shared history, WHY IN 2022 IS THIS NOT DEFAULT
setopt inc_append_history
setopt share_history

# Created by `pipx` on 2023-07-19 01:33:08
# (Didn't I do this already?! Trouble is brewing.)
export PATH="$PATH:$HOME/.local/bin"

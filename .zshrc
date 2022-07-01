# Enable homebrew completions
if type brew &>/dev/null
then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

    autoload -Uz compinit
    compinit
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

# Activate my work config
WORK_CONFIG_FILE="$HOME/code/work/config.zsh"
if [[ -f "$WORK_CONFIG_FILE" ]]
then
    . $WORK_CONFIG_FILE
else
    echo "WARNING: Work Config not found; have you set up yadm yet? (Skipping work config...)"
fi

# Enable spaceship PS1 prompt
autoload -U promptinit; promptinit
prompt spaceship


### Helpful aliases 'n such
alias vim="nvim"

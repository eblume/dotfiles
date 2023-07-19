# Enable ssh-agent early if its not running
# (Added for WSL)
if [ -z "$(pgrep ssh-agent)" ]; then
    # rm -rf /tmp/ssh-*
    echo "~/.zshrc: new ssh agent"
    eval $(ssh-agent -s) > /dev/null
else
    export SSH_AGENT_PID=$(pgrep ssh-agent)
    # export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name agent.*)
fi

# Enable homebrew completions
if type brew &>/dev/null
then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    # Note, we will compinit later on
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

# Enable shared history, WHY IN 2022 IS THIS NOT DEFAULT
setopt inc_append_history
setopt share_history

# Created by `pipx` on 2023-07-19 01:33:08
# (Didn't I do this already?! Trouble is brewing.)
export PATH="$PATH:$HOME/.local/bin"

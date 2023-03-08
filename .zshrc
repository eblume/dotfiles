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


### Helpful aliases 'n such
alias vim="nvim"

# Misc
export PYTHONDONTWRITEBYTECODE=1
export GPG_TTY=$(tty)  # needed for yadm encrypt (via gpg)

# Enable chef
## (Disabled because it was interfering with PATH stuff; might be kludgeable)
#if type chef > /dev/null; then
#    eval "$(chef shell-init zsh)"
#fi

# Enable shared history, WHY IN 2022 IS THIS NOT DEFAULT
setopt inc_append_history
setopt share_history


### Automatically box in to a new zellij session if one doesn't exist
eval "$(zellij setup --generate-auto-start zsh)"

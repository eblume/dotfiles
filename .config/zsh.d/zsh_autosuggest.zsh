### zsh-autosuggestions via homebrew
if type brew &>/dev/null
then
    if brew ls --versions zsh-autosuggestions > /dev/null
    then
        source $(brew --prefix zsh-autosuggestions)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    else
        echo "WARNING: zsh-autosuggestions not found, have you bootstrapped? (Skipping zsh-autosuggestions...)"
    fi
fi

ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion history)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20


## Optimization: Manual Rebinding for Widgets
# If this causes weird input issues such as not being able to type, try removing this section.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1


# ctrl-space autosuggest accept
# bindkey '^ ' autosuggest-accept
# DISABLED: this input sequence is overwritten by vim mode, but I discovered that some other widget is bound to the right
# arrow key, so just use right arrow key for now. Not too bad.


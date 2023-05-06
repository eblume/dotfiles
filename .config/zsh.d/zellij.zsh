### Automatically box in to a new zellij session if one doesn't exist and we aren't SSHing
if [ -z "$SSH_CONNECTION" ]; then
  eval "$(zellij setup --generate-auto-start zsh)"
fi

### Helpful aliases, originally from the --generate-completion zsh output, moved here
function zr () { zellij run --name "$*" -- zsh -ic "$*";}
function zrf () { zellij run --name "$*" --floating -- zsh -ic "$*";}
function ze () { zellij edit "$*";}
function zef () { zellij edit --floating "$*";}

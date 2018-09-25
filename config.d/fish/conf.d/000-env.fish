set PATH ~/code/notreon/dotfiles/bin $PATH  # personal binaries
set N_PREFIX ~/n 
set PATH $N_PREFIX/bin $PATH  # n shims
set PATH ~/.npm-global/bin $PATH  # npm modules

set --export EDITOR vim

# pyenv stuff, the plugin is being weird
set -x PATH "/home/erich/.pyenv/bin" $PATH
status --is-interactive; and source (pyenv init -|psub)
status --is-interactive; and source (pyenv virtualenv-init -|psub)


# Golang
set -x GOPATH ~/.config/go
set PATH /usr/lib/go-1.10/bin/ $PATH


# pbcopy/pbpaste like in OS X because my brain is mush
alias pbcopy "xsel --clipboard --input"
alias pbpaste "xsel --clipboard --output"


# some silly stuff
set PATH ~/code/patreon/devx-protec $PATH

# go

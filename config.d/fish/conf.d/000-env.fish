set PATH ~/code/notreon/dotfiles/bin $PATH  # personal binaries
set N_PREFIX ~/n 
set PATH $N_PREFIX/bin $PATH  # n shims
set PATH ~/.npm-global/bin $PATH  # npm modules

set --export EDITOR vim

# pyenv stuff, the plugin is being weird
set -x PATH "/home/erich/.pyenv/bin" $PATH
status --is-interactive; and . (pyenv init -|psub)
status --is-interactive; and . (pyenv virtualenv-init -|psub)


# Problem: zsh-vi-mode loses all keybindings on normal mode. ARGH.
# https://github.com/jeffreytse/zsh-vi-mode/issues/4
#
# Solution: just reload fzf keybindings... and I guess add others one by one as I find them broken and remember about
# it. What a shitshow.

function zvm_after_init() {
  source $(brew --prefix)/opt/fzf/shell/key-bindings.zsh
}

source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

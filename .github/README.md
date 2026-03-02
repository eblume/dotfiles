# eblume dotfiles

Welcome to my dotfiles repository!

I use chezmoi with 1password to configure sensitive information I don't wish to
publicly disclose, such as my work configuration. This means this repository is
of limited use except perhaps as a reference to people other than myself.

I use mise to install language toolchain dependencies, and I use homebrew to
install my general development platform (including mise and chezmoi). The core
configs for these tools are handled by chezmoi in this repository, but projects
can specify their own dependencies as well.

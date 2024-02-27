brew "mas"
brew "bash" # notebook prefers modern bash
brew "asdf"
brew "pipx"
brew "ykman" # yubikey
cask "discord"
cask "protonmail-bridge"
brew "zsh-vi-mode"
brew "zellij"
brew "gettext"
brew "watch"
brew "zsh-autosuggestions"
brew "readline"
brew "openssl"
brew "neovim"
brew "fzf"
brew "bat"
brew "git-delta"
brew "ripgrep"
brew "z"
brew "gnupg"
brew "jaq"  # jq, rewritten in rust
brew "yq"
cask "aws-vault"
brew "awscli"
cask "iterm2"
cask "todoist"
brew "starship"
brew "wget"
brew "ffmpeg"
brew "dive" # container exploration
brew "imagemagick"
# cask "firefox"  # Easier to just install it myself for now
brew "eza"
brew "bfs"

# 1password CLI, _not_ the GUI cask
tap "1password/tap"
cask "1password/tap/1password-cli"
# And now the actual GUI cask, which is seperate and has caused me issues:
cask "1password"
# mas "1Password 7", id: 1333542190  # 1password 7 via mac store if needed, but 8 is out now...
# ( See https://1password.com/mac-app-store-subscribe/ )

# my_summarize
brew "lynx"
brew "poppler"

# nvim ale/lsp stuff
brew "shellcheck"
brew "shfmt"

# yadm (note: yadm will always be installed first as the first yadm bootstrap command necessarily requires a
# pre-existing yadm command)
brew "yadm"

# Stuff to be pretty
brew "cowsay"
brew "lolcat"
tap "homebrew/cask-fonts"
cask "font-hack-nerd-font"

#github integration
brew "gh"
brew "cmake"  # needed for a dependency, telescope-fzf-native.nvim

# prereqs and suggestions for nb
brew "pandoc"
brew "tig"
brew "w3m"
brew "nb"

# Host-specific Brewfile hack
# Use ruby eval and IO.read to read ~/.Brewfile-host, if it exists
# (See https://github.com/Homebrew/homebrew-bundle/issues/521)
# (Also note that yadm provides this file.)
eval(IO.read(File.expand_path("~/.Brewfile-host"))) if File.exist?(File.expand_path("~/.Brewfile-host"))

# And finally, stuff from the apple store:
# NOTE, you will need to manually "purchase" these once before they can be installed via brew
# TODO: handle 1password this way? Maybe?
mas "Just Press Record", id: 1033342465

## Work Stuff
brew "gnu-tar"
brew "libsass"

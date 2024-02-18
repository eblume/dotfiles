# Source: https://davi.sh/blog/2024/01/nix-darwin/
{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
        url = "github:LnL7/nix-darwin";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = {pkgs, ... }: {

        services.nix-daemon.enable = true;
        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility. please read the changelog
        # before changing: `darwin-rebuild changelog`.
        system.stateVersion = 4;

        # The platform the configuration will be used on.
        # If you're on an Intel system, replace with "x86_64-darwin"
        nixpkgs.hostPlatform = "aarch64-darwin";

        # Declare the user that will be running `nix-darwin`.
        users.users.erichdblume = {
            name = "erichdblume";
            home = "/Users/erichdblume";
        };

        # Enable touch id for sudo
        security.pam.enableSudoTouchIdAuth = true;

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true;

        environment.systemPackages = [ pkgs.neofetch pkgs.vim ];

        homebrew = {
            enable = true;
            # When able, uncomment this to begin declarative management of homebrew
            # onActivation.cleanup = "uninstall";
            # (And then start wittling away at these brews and casks to get them into nixpkgs)
            taps = ["1password/tap" "homebrew/cask-fonts"];
            brews = [
                "bash"
                "asdf"
                "pipx"
                "ykman"
                "zsh-vi-mode"
                "zellij"
                "gettext"
                "watch"
                "zsh-autosuggestions"
                "readline"
                "openssl"
                "neovim"
                "fzf"
                "bat"
                "git-delta"
                "ripgrep"
                "z"
                "gnupg"
                "jaq"
                "yq"
                "awscli"
                "starship"
                "wget"
                "ffmpeg"
                "dive"
                "imagemagick"
                "lynx"
                "poppler"
                "shellcheck"
                "shfmt"
                "yadm"
                "cowsay"
                "lolcat"
                "gh"
                "cmake"
                "pandoc"
                "tig"
                "w3m"
                "nb"
            ];
            casks = [
                "protonmail-bridge"
                "aws-vault"
                "iterm2"
                "todoist"
                "1password/tap/1password-cli"
                "1password"
                "font-hack-nerd-font"
            ];
        };
    };
  in
  {
    darwinConfigurations."mouse" = nix-darwin.lib.darwinSystem {
      modules = [
         configuration
      ];
    };
  };
}

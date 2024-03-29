# Source: https://davi.sh/blog/2024/01/nix-darwin/
{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager}:
  let
    nix-darwin-config = {pkgs, ... }: {

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

      environment.systemPackages = with pkgs; [
        neofetch  # Useful for testing
        asdf-vm  # Installed here, but managed by yadm bootstrap
      ];

      homebrew = {
        enable = true;
        # When able, uncomment this to begin declarative management of homebrew
        # onActivation.cleanup = "uninstall";
        # (And then start wittling away at these brews and casks to get them into nixpkgs)
        taps = ["1password/tap" "homebrew/cask-fonts"];
        brews = [
          "awscli"
          "bash"
          "bat"
          "cmake"
          "cowsay"
          "dive"
          "eza"
          "bfs"
          "ffmpeg"
          "fzf"
          "gettext"
          "gh"
          "git-delta"
          "gnupg"
          "imagemagick"
          "jaq"
          "lolcat"
          "lynx"
          "nb"
          "neovim"
          "openssl"
          "pandoc"
          "pipx"
          "poppler"
          "readline"
          "ripgrep"
          "shellcheck"
          "shfmt"
          "starship"
          "tig"
          "w3m"
          "watch"
          "wget"
          "yadm"
          "ykman"
          "yq"
          "z"
          "zellij"
          "zsh-autosuggestions"
          "zsh-vi-mode"
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
        masApps = {
          "Just Press Record" = 1033342465;
        };
      };
    };

    home-manager-config = {pkgs, ...}: {
      # See https://davi.sh/blog/2024/02/nix-home-manager/
      home.stateVersion = "23.05";
      # Let home-manager manage itself
      programs.home-manager.enable = true;

      home.packages = with pkgs; [
        texlive.combined.scheme-full
      ];

      home.sessionVariables = {
        EDITOR = "nvim";
      };
    };

    in

    {
      darwinConfigurations."mouse" = nix-darwin.lib.darwinSystem {
        modules = [
          nix-darwin-config
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users.erichdblume = home-manager-config;
          }
        ];
      };

    };
}

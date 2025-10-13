{
  config,
  pkgs,
  lib,
  ...
}:
{

  # Homebrew - Mac-specific packages that aren't in Nix
  config = lib.mkIf pkgs.stdenv.isDarwin {

    # Requires Homebrew to be installed
    system.activationScripts.homebrew.text = lib.mkAfter ''
      if ! xcode-select --version 2>/dev/null; then
        $DRY_RUN_CMD xcode-select --install
      fi
      if ! /opt/homebrew/bin/brew --version 2>/dev/null; then
        $DRY_RUN_CMD /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
    '';

    # Add homebrew paths to CLI path
    home-manager.users.${config.user} = {
      home.sessionPath = [ "/opt/homebrew/bin/" ];
    };

    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = true; # Consider disabling for a more nix-y experience
        # cleanup = "zap"; # Uninstall all programs not declared
        upgrade = true;
      };
      global = {
        brewfile = true; # Run brew bundle from anywhere
        lockfiles = false; # Don't save lockfile (since running from anywhere)
      };
      taps = [ "1password/tap" ];
      brews = [
        "trash" # Delete files and folders to trash instead of rm
        "eza" # modern ls
        "ansible-lint"
        "jsonlint"
        "yq"
        "awscli"
        "aws-vault"
        "chezmoi"
        "starship"
        "mise"
      ];
      casks = [
        "1password" # 1Password will not launch from Nix on macOS
        "1password/tap/1password-cli"
        "iterm2"
        "obsidian"
        "slack"
        "todoist-app"
        "session-manager-plugin"
        "wezterm" # see https://github.com/iss/wezterm/issues/6731#issuecomment-2690905891
        # (we use /Applications/WezTerm.app/ on darwin, but still install nixpkgs)
      ];
      masApps = {
        "Just Press Record" = 1033342465;
        "Kagi for Safari" = 1622835804;
        "1Password for Safari" = 1569813296;
        "Magnet" = 441258766;
      };
    };
  };
}

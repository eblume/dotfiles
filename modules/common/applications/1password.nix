{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    _1password = {
      enable = lib.mkEnableOption {
        description = "Enable 1Password.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.gui.enable && config._1password.enable) {
    unfreePackages = [
      "1password"
      "_1password-gui"
      "1password-cli"
    ];
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        _1password-gui
        _1password
        git-credential-1password
      ];

      programs._1password-shell-plugins = {
        enable = true;
        # Example: plugins for 1Password for other CLIs:
        # plugins = with pkgs; [gh awscli2 cachix];
        # see: https://github.com/1Password/shell-plugins
      };
    };

    # Set SSH_AUTH_SOCK for 1password agent
    # NOTE: This doesn't seem to work at all - possibly because fish bypasses ~/.profile?
    # Instead, there's a HACK in modules/common/shell/fish/default.nix
    # which sets SSH_AUTH_SOCK in the fish interactive shell handler.
    environment.variables.SSH_AUTH_SOCK = config.ssh-agent-socket;

    # https://1password.community/discussion/135462/firefox-extension-does-not-connect-to-linux-app
    # On Mac, does not apply: https://1password.community/discussion/142794/app-and-browser-integration
    # However, the button doesn't work either:
    # https://1password.community/discussion/140735/extending-support-for-trusted-web-browsers
    environment.etc."1password/custom_allowed_browsers".text = ''
      ${
        config.home-manager.users.${config.user}.programs.firefox.package
      }/Applications/Firefox.app/Contents/MacOS/firefox
      firefox
    '';
  };
}

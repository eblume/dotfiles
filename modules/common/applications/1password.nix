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
      ];

      # Note: something I don't understand about nix mergeing means this next bit may be overwritten in modules/work/ssh.nix
      programs.ssh = {
        enable = true;
        matchBlocks."*".extraOptions.IdentityAgent = config.ssh-agent-socket;
      };
    };
  };
}

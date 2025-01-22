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
      # On darwin, this is handled by homebrew - see modules/darwin/homebrew.nix
      home.packages =
        if !pkgs.stdenv.isDarwin then
          with pkgs;
          [
            _1password-gui
            _1password
          ]
        else
          [ ];

      home.file._1passwordAgent = {
        text = ''
          [[ssh-keys]]
          vault = "Private"
          [[ssh-keys]]
          vault = "Payrix"
        '';
        target = ".config/1Password/ssh/agent.toml";
      };

      # Note: something I don't understand about nix mergeing means this next bit may be overwritten in modules/work/ssh.nix
      programs.ssh = {
        enable = true;
        matchBlocks."*".extraOptions.IdentityAgent = config.ssh-agent-socket;
      };
    };
  };
}

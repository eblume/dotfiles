{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    todoist = {
      enable = lib.mkEnableOption {
        description = "Enable Todoist.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.todoist.enable) {
    unfreePackages = [ "todoist-electron" ];
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [ todoist-electron ];
    };
  };
}

{ config, lib, ... }:
{
  config = {
    home-manager.users.${config.user} = {
      programs.firefox.enable = true;
    };

    environment.etc = lib.mkIf (config._1password.enable) {
      "1password/custom_allowed_browsers" = {
        text = ''
          firefox
        '';
        mode = "0755";
      };
    };
  };
}

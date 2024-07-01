{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    awscli = {
      enable = lib.mkEnableOption {
        description = "Enable AWS-cli.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.awscli.enable) {
    home-manager.users.${config.user} = {
      programs.awscli.enable = true;
    };

    users.users.${config.user}.packages = [ pkgs.aws-vault ];
  };
}

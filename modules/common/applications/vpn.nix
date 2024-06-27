{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    ovpn = {
      enable = lib.mkEnableOption "OpenVPN.";
      default = false;
    };
  };

  config = lib.mkIf (config.ovpn.enable) {
    home-manager.users.${config.user} = {
      home.packages = [ pkgs.openvpn ];
    };
  };
}

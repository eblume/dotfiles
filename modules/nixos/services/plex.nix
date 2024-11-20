{
  config,
  pkgs,
  lib,
  ...
}:
{

  config = lib.mkIf config.services.plex.enable {
    services.plex = {
      openFirewall = true;
    };

    systemd.services.plex.environment = {
      LD_LIBRARY_PATH = lib.mkForce "${pkgs.plex}/lib:/run/opengl-driver/lib";
    };
  };
}

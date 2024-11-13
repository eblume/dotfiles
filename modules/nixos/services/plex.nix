{
  config,
  lib,
  ...
}:
{

  config = lib.mkIf config.services.plex.enable {
    services.plex = {
      openFirewall = true;
    };
  };
}

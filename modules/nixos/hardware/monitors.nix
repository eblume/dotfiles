{
  config,
  pkgs,
  lib,
  ...
}:
{

  config = lib.mkIf config.gui.enable {

    environment.systemPackages = with pkgs; [
      ddcutil # Monitor brightness control
    ];

    # Reduce blue light at night
    services.redshift = {
      enable = true;
      brightness = {
        day = "1.0";
        night = "1.0";
      };
    };
  };
}

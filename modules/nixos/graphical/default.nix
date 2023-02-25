{ lib, ... }: {

  imports =
    [ ./xorg.nix ./fonts.nix ./i3.nix ./polybar.nix ./picom.nix ./rofi.nix ];

  options = {

    launcherCommand = lib.mkOption {
      type = lib.types.str;
      description = "Command to use for launching";
    };
    systemdSearch = lib.mkOption {
      type = lib.types.str;
      description = "Command to use for interacting with systemd";
    };
    altTabCommand = lib.mkOption {
      type = lib.types.str;
      description = "Command to use for choosing windows";
    };
    toggleBarCommand = lib.mkOption {
      type = lib.types.str;
      description = "Command to hide and show the status bar.";
    };
    wallpaper = lib.mkOption {
      type = lib.types.path;
      description = "Wallpaper background image file";
    };

  };

}
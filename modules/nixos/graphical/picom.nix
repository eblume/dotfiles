{
  config,
  pkgs,
  lib,
  ...
}:
{

  config = lib.mkIf (pkgs.stdenv.isLinux && config.services.xserver.enable) {
    home-manager.users.${config.user} = {

      services.picom = {
        enable = true;
        backend = "glx";
        settings = {
          blur = false;
          blurExclude = [ ];
          inactiveDim = "0.05";
          noDNDShadow = false;
          noDockShadow = false;
          # shadow-radius = 20
          # '';
          # shadow-radius = 20
          # corner-radius = 10
          # blur-size = 20
          # rounded-corners-exclude = [
          # "window_type = 'dock'",
          # "class_g = 'i3-frame'"
          # ]
          # '';
        };
        fade = false;
        inactiveOpacity = 1.0;
        menuOpacity = 1.0;
        opacityRules = [
          "0:_NET_WM_STATE@[0]:32a = '_NET_WM_STATE_HIDDEN'" # Hide tabbed windows
        ];
        shadow = false;
        shadowExclude = [ ];
        shadowOffsets = [
          (-10)
          (-10)
        ];
        shadowOpacity = 0.5;
        vSync = true;
        extraArgs = [
          # See: https://github.com/yshui/picom/issues/1265
          # logs were being spammed with:
          # "Duplicate vblank event found with msc 32767. Possible NVIDIA bug?"
          # This may also have been the cause of nonresponsiveness after sleep,
          # if so consider removing anti-sleeping-aids in power.nix
          "--no-frame-pacing"
        ];
      };

      xsession.windowManager.i3.config.startup = [
        {
          command = "systemctl --user restart picom";
          always = true;
          notification = false;
        }
      ];
    };
  };
}

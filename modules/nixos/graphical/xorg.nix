{
  config,
  pkgs,
  lib,
  ...
}:
{

  config = lib.mkIf config.gui.enable {

    # Enable touchpad support
    services.libinput.enable = true;

    # Enable the X11 windowing system.
    services.xserver = {
      enable = config.gui.enable;

      # Login screen
      displayManager = {
        # lightdm = {
        #   enable = config.services.xserver.enable;
        #   background = config.wallpaper;
        #
        #   # Show default user
        #   # Also make sure /var/lib/AccountsService/users/<user> has SystemAccount=false
        #   extraSeatDefaults = ''
        #     greeter-hide-users = false
        #   '';
        # };
        gdm.enable = config.services.xserver.enable;
      };
    };

    # Grasping at straws:
    security.polkit.enable = true;

    # Whitelist nvidia packages - I don't know where this belongs
    unfreePackages = [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
    ];

    # Don't know why but I just hit this:
    # https://discourse.nixos.org/t/hardware-nvidia-open-is-used-but-not-defined-error-when-updating-nixos-flake-config/51359
    hardware.nvidia.open = false;

    environment.systemPackages = with pkgs; [
      xclip # Clipboard
    ];

    home-manager.users.${config.user} = {

      programs.fish.shellAliases = {
        pbcopy = "xclip -selection clipboard -in";
        pbpaste = "xclip -selection clipboard -out";
      };
    };
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:

let

  # These micro-scripts change the volume while also triggering the volume
  # notification widget

  increaseVolume = pkgs.writeShellScriptBin "increaseVolume" ''
    ${pkgs.pamixer}/bin/pamixer -i 2
    volume=$(${pkgs.pamixer}/bin/pamixer --get-volume)
  '';

  decreaseVolume = pkgs.writeShellScriptBin "decreaseVolume" ''
    ${pkgs.pamixer}/bin/pamixer -d 2
    volume=$(${pkgs.pamixer}/bin/pamixer --get-volume)
  '';

  toggleMute = pkgs.writeShellScriptBin "toggleMute" ''
    ${pkgs.pamixer}/bin/pamixer --toggle-mute
    mute=$(${pkgs.pamixer}/bin/pamixer --get-mute)
    if [ "$mute" != "true" ]; then
        volume=$(${pkgs.pamixer}/bin/pamixer --get-volume)
    fi
  '';
in
{

  config = lib.mkIf (pkgs.stdenv.isLinux && config.gui.enable) {
    hardware.pulseaudio.enable = false;
    # A module for ‘rtkit’, a DBus system service that hands out realtime
    # scheduling priority to processes that ask for it.
    security.rtkit.enable = true;

    # Enable PipeWire
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };

    # Enable bluetooth
    # TODO move to bluetooth.nix ?
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = true;

    # Provides audio source with background noise filtered
    programs.noisetorch.enable = true;

    # These aren't necessary, but helpful for the user
    environment.systemPackages = with pkgs; [
      pamixer # Audio control
    ];

    home-manager.users.${config.user} = {

      xsession.windowManager.i3.config = {

        # i3 keybinds for changing the volume
        keybindings = {
          "XF86AudioRaiseVolume" = "exec --no-startup-id ${increaseVolume}/bin/increaseVolume";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${decreaseVolume}/bin/decreaseVolume";
          "XF86AudioMute" = "exec --no-startup-id ${toggleMute}/bin/toggleMute";
          # We can mute the mic by adding "--default-source"
          "XF86AudioMicMute" =
            "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute";
        };
      };
    };
  };
}

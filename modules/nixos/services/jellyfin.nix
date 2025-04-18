# Jellyfin is a self-hosted video streaming service. This means I can play my
# server's videos from a webpage, mobile app, or TV client.

{
  config,
  pkgs,
  lib,
  ...
}:
{

  config = lib.mkIf config.services.jellyfin.enable {
    # Create a 'media' group
    users.groups.media = { };
    users.users.${config.user}.extraGroups = [ "media" ];

    # Create a jellyfin user in the media group
    services.jellyfin.group = "media";
    users.users.jellyfin = {
      isSystemUser = true;
    };

    # Enable VA-API for hardware transcoding
    hardware.graphics = {
      enable = true;
      extraPackages = [ pkgs.libva ];
    };
    environment.systemPackages = with pkgs; [
      cifs-utils
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
      libva-utils
      nvidia-vaapi-driver
    ];
    environment.variables = {
      # VAAPI and VDPAU config for accelerated video.
      # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
      "VDPAU_DRIVER" = "nvidia";
      "LIBVA_DRIVER_NAME" = "nvidia";
    };
    users.users.jellyfin.extraGroups = [
      "render"
      "video"
    ]; # Access to /dev/dri

    # Fix issue where Jellyfin-created directories don't allow access for media group
    systemd.services.jellyfin.serviceConfig.UMask = lib.mkForce "0007";
  };
}

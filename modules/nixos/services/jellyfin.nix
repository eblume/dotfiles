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

    # Mount the sifaka/allisonflix SMB share
    fileSystems."/mnt/sifaka/allisonflix" = {
      device = "//sifaka/allisonflix";
      fsType = "cifs";
      options =
        let
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
          uid = "990";
          gid = "988";
        in
        # /etc/nixos/smb-secrets is hardcoded, for ref see 1password "sifaka | synology"
        [
          "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=${uid},gid=${gid},file_mode=0770,dir_mode=0770"
        ];
    };

    # Enable VA-API for hardware transcoding
    hardware.graphics = {
      enable = true;
      extraPackages = [ pkgs.libva ];
    };
    environment.systemPackages = [
      pkgs.cifs-utils
      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
      pkgs.libva-utils
      pkgs.nvidia-vaapi-driver
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

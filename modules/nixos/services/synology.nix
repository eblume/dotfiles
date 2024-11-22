{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    synology = {
      enable = lib.mkEnableOption {
        description = "Enable synology SMB shares.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.synology.enable) {
    environment.systemPackages = [ pkgs.cifs-utils ];
    fileSystems."/mnt/sifaka/allisonflix" = {
      device = "//sifaka/allisonflix";
      fsType = "cifs";
      options =
        let
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        in
        [ "${automount_opts},credentials=/etc/nixos/smb-secrets" ];
    };
  };
}

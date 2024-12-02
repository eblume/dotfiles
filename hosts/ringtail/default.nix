# Ringtail
# NixOS PC with nvidia RTX 4080

{
  inputs,
  globals,
  overlays,
  ...
}:

inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { };
  modules = [
    globals
    inputs.home-manager.nixosModules.home-manager
    {
      nixpkgs.overlays = overlays;
      networking.hostName = "ringtail";
      gui.enable = true;
      physical = true;
      server = false;
      ssh-agent-socket = "/home/eblume/.1password/agent.sock";
      theme = {
        colors = (import ../../colorscheme/gruvbox-dark).dark;
        dark = true;
      };
      charm.enable = true;
      wallpaper = "${inputs.wallpapers}/gruvbox/road.jpg";
      gtk.theme.name = inputs.nixpkgs.lib.mkDefault "Adwaita-dark";

      # Programs and services
      tailscale.enable = true;
      todoist.enable = true;
      neovim.enable = true;
      dotfiles.enable = true;
      yt-dlp.enable = true;
      media.enable = true;
      _1password.enable = true;
      wezterm.enable = true;
      python.enable = true;
      gaming = {
        enable = true;
        steam.enable = true;
      };
      services.jellyfin.enable = true;
      # Not intended as secure, just guards physical access
      passwordHash = "$6$jmd10dn10dh$V7pTqgp0xqMqOvjoqFBS.SjhrS8P8KT66EPS6Q0ydbGVVBBDBAuQ.QfkHKeyevQaByPmO9co7v7itr6iZtOZV/";

      # Boot options & drivers
      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      # Filesystem

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/0d6dc37d-17cf-4987-8c8b-ff2337609594";
          fsType = "ext4";
        };

        "/boot" = {
          device = "/dev/disk/by-uuid/D726-9E86";
          fsType = "vfat";
          options = [
            "fmask=0022"
            "dmask=0022"
          ];
        };

        "/mnt/sifaka/allisonflix" = {
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

        "/mnt/store1" = {
          device = "/dev/disk/by-label/store1";
          fsType = "ext4";
        };
        "/mnt/store2" = {
          device = "/dev/disk/by-label/store2";
          fsType = "ext4";
        };
        "/mnt/store3" = {
          device = "/dev/disk/by-label/store3";
          fsType = "ext4";
        };
      };
      swapDevices = [
        {
          device = "/dev/disk/by-label/swap";
        }
      ];

      networking.networkmanager.enable = true;
      services.openssh.enable = true;
      publicKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILmh1SSCdDAyu3vkSQH7kAXEPDi8APyjo9JXDTjtha2j"
      ];

      services.xserver.videoDrivers = [ "nvidia" ];

      # Time & Locale
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      # Bluetooth
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
      services.blueman.enable = true;
    }
    ../../modules/common
    ../../modules/nixos
  ];
}

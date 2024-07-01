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
      wallpaper = "${inputs.wallpapers}/gruvbox/road.jpg";
      gtk.theme.name = inputs.nixpkgs.lib.mkDefault "Adwaita-dark";

      # Programs and services
      firefox.enable = true;
      neovim.enable = true;
      dotfiles.enable = true;
      # media.enable = true;
      # firefox.enable = true;
      kitty.enable = true;
      _1password.enable = true;
      wezterm.enable = true;
      gaming = {
        enable = true;
        steam.enable = true;
      };

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
      fileSystems."/" = {
        device = "/dev/disk/by-uuid/0d6dc37d-17cf-4987-8c8b-ff2337609594";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/D726-9E86";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };

      swapDevices = [ ];

      # Networking
      networking.networkmanager.enable = true;

      # Time & Locale
      time.timeZone = "America/Los_Angeles";
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

      # Graphics
      services.xserver.videoDrivers = [ "nvidia" ];

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

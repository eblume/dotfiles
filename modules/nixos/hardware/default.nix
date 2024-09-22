{ lib, ... }:
{

  imports = [
    ./audio.nix
    ./boot.nix
    ./disk.nix
    ./keyboard.nix
    ./monitors.nix
    ./mouse.nix
    ./networking.nix
    ./power.nix
    ./server.nix
    ./wifi.nix
  ];

  options = {
    physical = lib.mkEnableOption "Whether this machine is a physical device.";
    server = lib.mkEnableOption "Whether this machine is a server.";
  };
}

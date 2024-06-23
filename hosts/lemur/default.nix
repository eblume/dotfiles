# Lemur
# 'guest' NixOS setup intended for containers, AMIs, ISOs, qemu images, etc.
# Think of this as a 'platonic' platform target.

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
      networking.hostName = "lemur";
      gui.enable = false;
      physical = false;
      theme = {
        colors = (import ../../colorscheme/gruvbox-dark).dark;
        dark = true;
      };
      neovim.enable = true;
      ssh-agent-socket = "/home/eblume/.1password/agent.sock";
    }
    ../../modules/common
    ../../modules/nixos
  ];
}

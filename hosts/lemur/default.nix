# Lemur
# 'guest' NixOS setup intended for containers, AMIs, ISOs, qemu images, etc.
# Think of this as a 'platonic' platform target.

{
  inputs,
  globals,
  overlays,
  ...
}:

inputs.darwin.lib.darwinSystem {
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
      ssh-agent-socket = "/Users/erichdblume/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    }
    ../../modules/common
    ../../modules/nixos
  ];
}

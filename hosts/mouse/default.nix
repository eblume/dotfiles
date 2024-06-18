# Mouse
# personal m1 macbook air

{
  inputs,
  globals,
  overlays,
  ...
}:

inputs.darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = { };
  modules = [
    ../../modules/common
    ../../modules/darwin
    (
      globals
      // rec {
        user = "erichdblume";
        gitName = "Erich Blume";
        gitEmail = "blume.erich@gmail.com";
      }
    )
    inputs.home-manager.darwinModules.home-manager
    {
      nixpkgs.overlays = [ inputs.firefox-darwin.overlay ] ++ overlays;
      networking.hostName = "mouse";
      identityFile = "/Users/erichdblume/.ssh/id_ed25519";
      gui.enable = true;
      theme = {
        colors = (import ../../colorscheme/gruvbox-dark).dark;
        dark = true;
      };
      neovim.enable = true;
    }
  ];
}

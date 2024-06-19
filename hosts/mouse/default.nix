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
      // {
        user = "erichdblume";
        gitName = "Erich Blume";
        gitEmail = "blume.erich@gmail.com";
      }
    )
    inputs.home-manager.darwinModules.home-manager
    {
      nixpkgs.overlays = [ inputs.firefox-darwin.overlay ] ++ overlays;
      networking.hostName = "mouse";
      gui.enable = true;
      theme = {
        colors = (import ../../colorscheme/gruvbox-dark).dark;
        dark = true;
      };
      neovim.enable = true;
      ssh-agent-socket = "/Users/erichdblume/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    }
  ];
}

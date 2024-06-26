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
        gitEmail = "725328+eblume@users.noreply.github.com";
      }
    )
    inputs.home-manager.darwinModules.home-manager
    {
      nixpkgs.overlays = [ inputs.firefox-darwin.overlay ] ++ overlays;
      networking.hostName = "mouse";
      gui.enable = true;
      kitty.enable = true;
      wezterm.enable = true;
      dotfiles.enable = true;
      terraform.enable = true;
      theme = {
        colors = (import ../../colorscheme/gruvbox-dark).dark;
        dark = true;
      };
      neovim.enable = true;
      ssh-agent-socket = "/Users/erichdblume/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    }
  ];
}
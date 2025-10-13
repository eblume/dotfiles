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
    (inputs.private_dotfiles + "/default.nix")
    (
      globals
      // {
        user = "eblume";
        gitName = "Erich Blume";
        gitEmail = "725328+eblume@users.noreply.github.com";
      }
    )
    inputs.home-manager.darwinModules.home-manager
    {
      # Not sure why this is needed, but it does seem to be needed.
      ids.gids.nixbld = 30000;

      nixpkgs.overlays = overlays;
      networking.hostName = "mouse";
      gui.enable = true;
      wezterm.enable = true;
      slack.enable = true;
      ovpn.enable = true;
      tailscale.enable = true;
      payrix-cli.enable = true;
      payrix-aws.enable = true;
      theme = {
        colors = (import ../../colorscheme/gruvbox-dark).dark;
        dark = true;
      };
      neovim.enable = true;
      ssh-agent-socket = "/Users/eblume/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    }
  ];
}

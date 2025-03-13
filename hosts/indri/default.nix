# indri
# m1 mac mini
# jellyfin server

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
        user = "erichblume";
        gitName = "Erich Blume";
        gitEmail = "725328+eblume@users.noreply.github.com";
      }
    )
    inputs.home-manager.darwinModules.home-manager
    {
      _1password.enable = true;
      nix.enable = false; # Not sure what's going on here.
      nix.gc.automatic = false;
      nixpkgs.overlays = overlays;
      networking.hostName = "indri";
      gui.enable = true;
      wezterm.enable = true;
      dotfiles.enable = true;
      slack.enable = true;
      llm.enable = true;
      charm.enable = true;
      tailscale.enable = true;
      awscli.enable = true;
      ovpn.enable = true;
      payrix-cli.enable = true;
      payrix-aws.enable = true;
      theme = {
        colors = (import ../../colorscheme/gruvbox-dark).dark;
        dark = true;
      };
      neovim.enable = true;
      ssh-agent-socket = "/Users/erichblume/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    }
  ];
}

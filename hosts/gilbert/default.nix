# Gilbert
# personal m4 macbook air

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
      _1password.enable = true;
      nixpkgs.overlays = overlays;
      nix.enable = false;
      networking.hostName = "gilbert";
      gui.enable = true;
      enableTerraform = true;
      wezterm.enable = true;
      dotfiles.enable = true;
      slack.enable = true;
      ovpn.enable = true;
      charm.enable = true;
      tailscale.enable = true;
      yt-dlp.enable = true;
      awscli.enable = true;
      payrix-cli.enable = true;
      payrix-aws.enable = true;
      kubernetes.enable = true;
      theme = {
        colors = (import ../../colorscheme/gruvbox-dark).dark;
        dark = true;
      };
      neovim.enable = true;
      ssh-agent-socket = "/Users/eblume/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    }
  ];
}

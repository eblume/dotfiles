# FIS-issued macbook
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

      _1password.enable = true;
      nixpkgs.overlays = overlays;
      networking.hostName = "ML5Y2969QP";
      gui.enable = true;
      wezterm.enable = true;
      dotfiles.enable = true;
      slack.enable = true;
      ovpn.enable = true;
      charm.enable = true;
      awscli.enable = true;
      payrix-cli.enable = true;
      payrix-aws.enable = true;
      theme = {
        colors = (import ../../colorscheme/gruvbox-dark).dark;
        dark = true;
      };
      neovim.enable = true;
      ssh-agent-socket = "/Users/eblume/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
      use_custom_root_cert = true;
    }
  ];
}

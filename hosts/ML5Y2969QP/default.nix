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
        gitEmail = "Erich.Blume@worldpay.com";
      }
    )
    inputs.home-manager.darwinModules.home-manager
    {
      nixpkgs.overlays = overlays;
      networking.hostName = "ML5Y2969QP";
      gui.enable = true;
      kitty.enable = false;
      wezterm.enable = true;
      dotfiles.enable = true;
      slack.enable = true;
      mole.enable = true;
      llm.enable = true;
      mise.enable = true;
      ovpn.enable = true;
      charm.enable = true;
      awscli.enable = true;
      obsidian.enable = true;
      payrix-cli.enable = true;
      theme = {
        colors = (import ../../colorscheme/gruvbox-dark).dark;
        dark = true;
      };
      neovim.enable = true;
      ssh-agent-socket = "/Users/erichdblume/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    }
  ];
}

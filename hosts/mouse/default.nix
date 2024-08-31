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
    ../../modules/work
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
      nixpkgs.overlays = overlays;
      networking.hostName = "mouse";
      gui.enable = true;
      kitty.enable = false;
      wezterm.enable = true;
      dotfiles.enable = true;
      slack.enable = true;
      mole.enable = true;
      llm.enable = true;
      ovpn.enable = true;
      charm.enable = true;
      tailscale.enable = true;
      awscli.enable = true;
      obsidian.enable = true;
      services.openssh.enable = true;
      publicKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILmh1SSCdDAyu3vkSQH7kAXEPDi8APyjo9JXDTjtha2j"
      ];
      theme = {
        colors = (import ../../colorscheme/gruvbox-dark).dark;
        dark = true;
      };
      neovim.enable = true;
      ssh-agent-socket = "/Users/eblume/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    }
  ];
}

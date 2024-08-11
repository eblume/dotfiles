{ pkgs, ... }:
rec {

  # Show quick helper
  default = import ./help.nix { inherit pkgs; };

  # Rebuild
  rebuild = import ./rebuild.nix { inherit pkgs; };

  # Run neovim as an app
  neovim = import ./neovim.nix { inherit pkgs; };
  nvim = neovim;

  # Show a nice help message
  help = import ./help.nix { inherit pkgs; };
}

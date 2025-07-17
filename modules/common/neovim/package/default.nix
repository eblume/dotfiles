{
  pkgs,
  colors,
  github ? false,
  kubernetes ? false,
  enableTerraform ? false,
  ...
}:

# Comes from nix2vim overlay:
# https://github.com/gytis-ivaskevicius/nix2vim/blob/master/lib/neovim-builder.nix
pkgs.neovimBuilder {
  package = pkgs.neovim-unwrapped;
  inherit
    colors
    github
    kubernetes
    enableTerraform
    ;
  imports = [
    ../config/align.nix
    ../config/colors.nix
    ../config/completion.nix
    ../config/gitlab.nix
    ../config/github.nix
    ../config/gitsigns.nix
    ../config/lsp.nix
    ../config/misc.nix
    ../config/statusline.nix
    ../config/syntax.nix
    ../config/telescope.nix
    ../config/toggleterm.nix
    ../config/tree.nix
    ../config/obsidian.nix
    ../config/sudoku.nix
  ];
}

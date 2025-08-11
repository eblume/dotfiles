# Obsidian in neovim via Obsidian.nvim
{ pkgs, ... }:
{
  plugins = [
    pkgs.vimPlugins.obsidian-nvim
    # treesitter imported via syntax.nix for plugin reasons
  ];

  # setup.obsidian is not included here but rather in obsidian.lua
  lua = ''
    ${builtins.readFile ./obsidian.lua}
  '';
}

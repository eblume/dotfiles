# Obsidian in neovim via Obsidian.nvim
# https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file
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

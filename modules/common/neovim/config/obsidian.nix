# Obsidian in neovim via Obsidian.nvim
# https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file
{ pkgs, ... }:
{
  plugins = [
    pkgs.vimPlugins.obsidian-nvim
    pkgs.vimPlugins.nvim-treesitter
  ];

  # setup.obsidian is not included here but rather in obsidian.lua
  lua = ''
    ${builtins.readFile ./obsidian.lua}
  '';
}

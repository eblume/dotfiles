# Obsidian in neovim via Obsidian.nvim
# https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file
{ pkgs, ... }:
{
  plugins = [
    pkgs.vimPlugins.obsidian-nvim
    pkgs.vimPlugins.nvim-treesitter
  ];

  lua = ''
    ${builtins.readFile ./obsidian.lua}
  '';

  # NOTE setup.obsidian is not included here but rather in
  # obsidian.lua, because the "checkboxes" section seems to use an
  # incompatible array-keyed dictionary syntax that I could not figure
  # out how to nixify.

}

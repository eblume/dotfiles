{ pkgs, ... }:
{
  plugins = [
    pkgs.vimPlugins.vim-fugitive
    pkgs.vimPlugins.vim-rhubarb
  ];
}

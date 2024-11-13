# This file imports all the other files in this directory for use as modules in
# my config.

{ ... }:
{

  imports = [
    ./jellyfin.nix
    ./sshd.nix
    ./plex.nix
  ];
}

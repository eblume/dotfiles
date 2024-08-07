{
  config,
  pkgs,
  lib,
  ...
}:

{
  home-manager.users.${config.user} = lib.mkIf pkgs.stdenv.isDarwin {

    home.packages = [
      pkgs.visidata # CSV inspector
      pkgs.dos2unix # Convert Windows text files
      pkgs.inetutils # Includes telnet
      pkgs.pandoc # Convert text documents
      pkgs.mpd # TUI slideshows
      pkgs.mpv # Video player
      pkgs.gnupg # Encryption
      pkgs.awscli2
      pkgs.ssm-session-manager-plugin
      pkgs.awslogs
      pkgs.noti # Create notifications programmatically
      pkgs.ipcalc # Make IP network calculations
    ];
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:

{
  home-manager.users.${config.user} = lib.mkIf pkgs.stdenv.isDarwin {

    home.packages = [
      pkgs.dos2unix # Convert Windows text files
      pkgs.inetutils # Includes telnet
      pkgs.pandoc # Convert text documents
      pkgs.gnupg # Encryption
      pkgs.awslogs
      pkgs.noti # Create notifications programmatically
    ];
  };
}

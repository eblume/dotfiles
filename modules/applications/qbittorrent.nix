{ config, pkgs, lib, ... }: {

  config = lib.mkIf config.gui.enable {

    home-manager.users.${config.user} = {

      home.packages = with pkgs; [ qbittorrent ];

    };
  };

}
{ pkgs, gui, ... }: {

  fonts.fonts = with pkgs;
    [
      gui.font.package # Used for Vim and Terminal
      # siji # More icons for Polybar
    ];
  fonts.fontconfig.defaultFonts.monospace = [ gui.font.name ];

}

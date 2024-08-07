{
  config,
  pkgs,
  lib,
  ...
}:

let

  neovim = import ./package {
    inherit pkgs;
    colors = config.theme.colors;
    github = true;
    kubernetes = config.kubernetes.enable;
  };
in
{

  options.neovim.enable = lib.mkEnableOption "Neovim.";

  config = lib.mkIf config.neovim.enable {
    home-manager.users.${config.user} =

      {

        home.packages = [ neovim ];

        # Use Neovim as the editor for git commit messages
        programs.git.extraConfig.core.editor = "nvim";
        programs.jujutsu.settings.ui.editor = "nvim";

        # Set Neovim as the default app for text editing and manual pages
        home.sessionVariables = {
          EDITOR = "nvim";
          MANPAGER = "nvim +Man!";
        };

        # Create quick aliases for launching Neovim
        programs.fish = {
          shellAliases = {
            vim = "nvim";
          };
          shellAbbrs = {
            v = lib.mkForce "nvim";
            vl = lib.mkForce "nvim -c 'normal! `0'";
            vll = "nvim -c 'Telescope oldfiles'";
          };
        };

        xdg.mimeApps.defaultApplications = lib.mkIf pkgs.stdenv.isLinux {
          "text/plain" = [ "nvim.desktop" ];
          "text/markdown" = [ "nvim.desktop" ];
        };
      };
  };
}

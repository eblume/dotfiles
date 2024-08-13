{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Mise https://github.com/jdx/mise  -- "dev tools, env vars, task runner"
  # (Multi-version runtime management, +)

  options.mise.enable = lib.mkEnableOption "Mise.";

  config = lib.mkIf config.mise.enable {
    home-manager.users.${config.user} = {
      programs.mise = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
        globalConfig = lib.mkDefault {
          tools = {
            python = "latest";
            poetry = "latest";
            node = "latest";
          };

          settings = {
            python_compile = true;
          };

          plugins = {
            poetry = "https://github.com/mise-plugins/mise-poetry";
          };
        };
      };
    };

    # Enable pyenv build via `mise install`
    # https://github.com/pyenv/pyenv/wiki#suggested-build-environment
    # (and see `python_compile`, above)
    environment.systemPackages = with pkgs; [
      libxcrypt
      zlib
      ncurses
      readline
      openssl
      bzip2
      sqlite
      xz
      tk
      libffi
      expat
      tcl
      pkgconf
    ];
  };
}

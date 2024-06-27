{ config, lib, ... }:
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
          };

          plugins = {
            poetry = "https://github.com/mise-plugins/mise-poetry";
          };
        };
      };
    };
  };
}

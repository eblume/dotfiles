{ config, lib, ... }:
{
  options = {
    payrix-cli = {
      enable = lib.mkEnableOption {
        description = "Enable the Payrix CLI";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.payrix-cli.enable) {
    home-manager.users.${config.user} = {
      programs.fish = {
        shellAliases.px = "mise x node@18 -- npx ${config.homePath}/code/work/devops/payrix-cli/";

        functions = {
          payrix-rds-pci = {
            description = "Connect to payrix-jobs-dev and echo a psql connection command";
            body = builtins.readFile ./functions/payrix-rds-pci.fish;
          };
          payrix-rds-sandbox = {
            description = "Connect to payrix-sandbox-jobs and echo a psql connection command";
            body = builtins.readFile ./functions/payrix-rds-sandbox.fish;
          };
          payrix-vpn = {
            description = "Start the payrix openvpn client using sudo";
            body = builtins.readFile ./functions/payrix-vpn.fish;
          };
          payrix-times = {
            description = "Print relevant time information for payrix";
            body = builtins.readFile ./functions/payrix-times.fish;
          };
          payrix-whitelist-sg = {
            description = "Attempts to whitelist the current host IP for payrix access";
            body = builtins.readFile ./functions/payrix-whitelist-sg.fish;
          };
        };
      };
    };
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
# let
# TODO: Actually compile and install the CLI rather than use an alias mise+npx hack
#   nodejs = pkgs.nodejs_18; # TODO modern node in payrix-cli
#   payrix-cli-src = builtins.fetchGit {
#     url = "git@gitlab.com:payrix/devops/payrix-cli";
#     ref = "oclif-4"; # TODO back to master when oclif-4 PR merged
#     rev = "2d4e7d2141e9ac503eb28c696e1716830c4219c4";
#   };
#   payrix-cli = pkgs.noxide.buildPackage payrix-cli-src {
#     name = "payrix-cli";
#     nodejs = nodejs;
#     npmCommands = [
#       # First, disable npm SSL audit -- it's broken for self-signed
#       # packages, and the proper solution is an artifact repository
#       "npm config set strict-ssl false"
#       # Default:
#       "npm install --prefer-offline --package-lock-only --no-fund --nodedir=${nodejs}/include/node"
#       # Compile typescript:
#       "npm run build"
#     ];
#   };
# in
{
  options = {
    payrix-cli = {
      enable = lib.mkEnableOption {
        description = "Enable the Payrix CLI";
        default = false;
      };
    };
  };

  # TODO stop requiring mise if above note on npm build is implemented
  config = lib.mkIf (config.payrix-cli.enable && config.mise.enable) {
    home-manager.users.${config.user} = {
      # home.packages = [ payrix-cli ];
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

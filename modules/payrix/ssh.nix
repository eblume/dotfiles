{ config, ... }:
let
  hosts = {
    payrix-bastion = "10.0.240.122";
    payrix-sandbox-api = "3.229.230.4";
    payrix-sandbox-jobs = "34.224.195.65";
    payrix-sandbox-portal = "3.216.249.216";
    payrix-qa = "54.243.149.29";
    payrix-portal = "52.7.184.35";
    payrix-api1 = "10.0.21.81";
    payrix-api2 = "10.0.23.122";
    payrix-api3 = "10.0.28.47";
    payrix-jobs1 = "10.0.20.36";
    payrix-jobs2 = "10.0.17.62";
    payrix-jobs-dev = "10.0.21.128";
    payrix-letsencrypt = "10.0.25.248";
  };
in
{
  config = {
    home-manager.users.${config.user} = {
      programs.ssh = {
        enable = true;
        matchBlocks =
          builtins.mapAttrs (name: address: {
            hostname = address;
            user = "erichb";
            port = 2202;
          }) hosts
          // {
            # TODO why won't this merge from 1password.nix??
            "*".extraOptions.IdentityAgent = config.ssh-agent-socket;
          };
      };
    };
  };
}

{ config, ... }:
let
  hosts = {
    payrix-api1 = "i-071d3f94aef8890b1";
    payrix-api2 = "i-08d64fae8e091d442";
    payrix-api3 = "i-07600937bdb1c80bd";
    payrix-bastion = "i-03e6070ca46e3111f";
    payrix-jobs-dev = "i-031f8bfebbf1d717d";
    payrix-jobs1 = "i-0d9d85c1350a03039";
    payrix-jobs2 = "i-0c2508ca707526f00";
    payrix-letsencrypt = "i-0632a9d823e7da6b3";
    payrix-portal = "i-04b5f3641185cf6d5";
    payrix-qa = "i-09c1b0645dc0062dd";
    payrix-sandbox-api = "i-070390dfc54ceab1b";
    payrix-sandbox-jobs = "i-07aec346e999c251b";
    payrix-sandbox-portal = "i-0c9c9c1c1508784ed";
    payrix-vpn = "i-01c29c02af2ca6cca";
  };
in
{
  config = {
    home-manager.users.${config.user} = {
      programs.ssh = {
        enable = true;
        matchBlocks = builtins.mapAttrs (name: address: { hostname = address; }) hosts // {
          "payrix-*" = {
            user = "erichb";
            port = 2202;
            proxyCommand = "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'";
          };

          # TODO why won't this merge from 1password.nix??
          "*".extraOptions.IdentityAgent = config.ssh-agent-socket;
        };
      };
    };
  };
}

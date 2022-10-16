{ config, pkgs, lib, ... }: {

  imports = [ ./secrets.nix ];

  config = {

    networking.wireguard = {
      enable = true;
      interfaces = {
        wg0 = {

          # Establishes identity of this machine
          generatePrivateKeyFile = false;
          privateKeyFile = config.secrets.wireguard.dest;

          # Move to network namespace for isolating programs
          interfaceNamespace = "wg";

        };
      };
    };

    # Create namespace for Wireguard
    # This allows us to isolate specific programs to Wireguard
    systemd.services."netns@" = {
      description = "%I network namespace";
      before = [ "network.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.iproute2}/bin/ip netns add %I";
        ExecStop = "${pkgs.iproute2}/bin/ip netns del %I";
      };
    };

    # Create private key file for wireguard
    secrets.wireguard = {
      source = ../../private/wireguard.age;
      dest = "${config.secretsDirectory}/wireguard";
    };

  };

}

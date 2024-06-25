{ config, lib, ... }:
{

  config = lib.mkIf config.physical {

    networking.useDHCP = !config.networking.networkmanager.enable;

    networking.firewall.allowPing = lib.mkIf config.server true;

    # DNS service discovery
    services.avahi = {
      enable = true;
      domainName = "local";
      ipv6 = false; # Should work either way
      # Resolve local hostnames using Avahi DNS
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        workstation = true;
      };
    };
  };
}

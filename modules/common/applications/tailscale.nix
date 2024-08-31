{
  config,
  lib,
  ...
}:
{
  options = {
    tailscale = {
      enable = lib.mkEnableOption {
        description = "Enable Tailscale client.";
        default = false;
      };
    };
  };

  # See: https://nixos.wiki/wiki/Tailscale
  # And: https://tailscale.com

  config = lib.mkIf (config.tailscale.enable) {
    services.tailscale.enable = true;
    # If using features like subnet routers or exit nodes:
    # services.tailscale.useRoutingFeatures = "server" or "client" or "both"
  };
}

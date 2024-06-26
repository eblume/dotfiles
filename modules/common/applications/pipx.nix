{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    pipx = {
      enable = lib.mkEnableOption {
        description = "Enable pipx package management.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.pipx.enable) {
    environment.systemPackages = [
      pkgs.pipx
      pkgs.neofetch
    ];
  };

  # TODO: How can we declare pipx packages?
}

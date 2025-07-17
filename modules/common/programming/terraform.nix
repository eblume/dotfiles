{ lib, ... }:
{
  options.enableTerraform = lib.mkEnableOption "Terraform tools.";
}

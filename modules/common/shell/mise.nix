{ config, ... }:
{
  # mise.jdx.dev - toolchain manager
  #
  # Nix and Mise sit at a bit of an awkward intersection, as both serve
  # some similar purposes. I think I would like to move as much as I
  # can in to mise, and let nix be a build tool more than a development
  # platform provider. Eventually I would like to have nix be a backend
  # that mise can choose to use (or not).

  home-manager.users.${config.user} = {
    programs.mise.enable = true;
    programs.mise.enableFishIntegration = true;
    programs.mise.enableBashIntegration = true;

    programs.mise.globalConfig = {
      tools = {
        "pipx:ansible-core" = {
          "version" = "2.16.11";
          "uvx_args" = "--with botocore --with boto3";
          "uvx" = true; # or else change ^ to pipx_args
        };
        python = "latest";
        rust = "latest";
        "pipx:eblume/mole" = "latest";
        "pipx:simonw/llm" = "latest";
        dotnet = "8";
        node = "latest";
        uv = "latest";
      };

      settings = {
        experimental = true;
        idiomatic_version_file_enable_tools = [ ];
      };
    };

  };
}

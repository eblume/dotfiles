{
  config,
  pkgs,
  lib,
  ...
}:
let
  # TODO -  use poetry sdist builds and github actions to deploy.
  # Currently, this uses buildPythonPackage + setuptools to build the python
  # package for mole with the appropriate sources. This is cumbersome and
  # worse, it duplicates the work of pyproject.toml + poetry. The obvious
  # solution is to use poetry2nix, but in my experience this project has
  # massive issues - many packages reported to miss their dependencies despite
  # having them listed. Instead, let poetry build a portable release file and
  # install via that.
  #
  # The present solution, given to me by @nmasur, works in the interim!
  # https://github.com/nmasur/dotfiles/commit/068cdbf5d464c3882473ea0218b954b9ddab8261

  mole = pkgs.python311.pkgs.buildPythonPackage {
    pname = "mole";
    version = "0.7.2";
    pyproject = true;

    src = pkgs.fetchFromGitHub {
      # regen with `nsr nix-prefetch-github eblume mole`
      # TODO - mole release process, semver, etc.
      owner = "eblume";
      repo = "mole";
      rev = "3295c9cf135bc1729aa316c495ce95c0742a43cd";
      sha256 = "sha256-Uj0S0p80MjUWisbtRcy3882Q/0H7a0/2TS2M54p4k6E=";
    };

    # buildtime
    nativeBuildInputs = [ pkgs.python311Packages.poetry-core ];

    # Build + runtime
    propagatedBuildInputs = with pkgs.python311Packages; [
      typer
      todoist-api-python
      openai
      rich
      watchdog
      pydub
      requests
      pyyaml
      pydantic
      pendulum
    ];

    build-system = [ pkgs.python311.pkgs.setuptools ];

    # No tests :(
    doCheck = false;
  };
in
{
  options = {
    mole = {
      enable = lib.mkEnableOption {
        description = "Enable mole.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.mole.enable) {
    unfreePackages = [
      "_1password"
      "1password-cli"
    ];
    home-manager.users.${config.user} = {
      home.packages = [
        mole
        pkgs.zellij
        pkgs._1password
        pkgs.nb
      ];
    };
  };
}

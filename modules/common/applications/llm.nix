{
  config,
  pkgs,
  lib,
  ...
}:
let
  # credit: https://github.com/jpetrucciani/nix/blob/3947483b426ef687709b9f78c2365614497475d9/mods/python/ai/bindings.nix#L644
  # regen with `nsr nix-prefetch-github eblume mole`
  groq = pkgs.python312.pkgs.buildPythonPackage {
    pname = "groq";
    version = "0.15.0";
    pyproject = true;

    src = pkgs.fetchFromGitHub {
      owner = "groq";
      repo = "groq-python";
      rev = "2b91340106d3e6b0f06f3cad4cfde436866cdfd2";
      sha256 = "sha256-RoUvUDgUO1M3pSZA0B0eimRvE8buF4FDaz+FD1a241I=";
    };

    nativeBuildInputs = with pkgs.python312.pkgs; [
      hatchling
      hatch-fancy-pypi-readme
      pydantic
    ];
    propagatedBuildInputs = with pkgs.python312.pkgs; [
      anyio
      cached-property
      distro
      httpx
      sniffio
      typing-extensions
    ];

    pythonImportsCheck = [ "groq" ];
    meta = {
      description = "The official Python library for the groq API";
      homepage = "https://pypi.org/project/groq/";
      # With apologies to jpetrucciani, I'm commenting this out in fear that
      # leaving it in would somehow flag this slightly altered version as being
      # his responsibility. If this is wrong, please file an issue! Still a nix
      # newbie.
      # maintainers = with maintainers; [ jpetrucciani ];

      # As for this one, leaving it in gives an error I don't understand at the moment
      # license = licenses.asl20;
    };
  };

  llm-groq = pkgs.python312.pkgs.buildPythonPackage {
    pname = "llm-groq";
    version = "0.7";
    pyproject = true;

    src = pkgs.fetchFromGitHub {
      owner = "angerman";
      repo = "llm-groq";
      rev = "57be10aeb6f69b31b067060209688982c409dd51"; # v0.7 27 Jan 2025
      sha256 = "sha256-N2VbcY8z7AppZe0X0sk/cKTvb+WlMmWBtTkoLamtKSM=";
    };

    propagatedBuildInputs = [ groq ];
    build-system = with pkgs.python312.pkgs; [
      setuptools
      llm
    ];
    doCheck = false;
  };
in
{
  options = {
    llm = {
      enable = lib.mkEnableOption {
        description = "Enable Simon Willison's python-based LLM tool.";
        default = false;
      };
    };
  };

  config = lib.mkIf config.llm.enable {
    home-manager.users.${config.user} = {
      home.packages = [
        (pkgs.python312.withPackages (ps: [
          ps.llm
          llm-groq
        ]))
      ];
    };
  };

}

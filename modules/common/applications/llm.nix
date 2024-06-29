{
  config,
  pkgs,
  lib,
  ...
}:
let
  # credit: https://github.com/jpetrucciani/nix/blob/3947483b426ef687709b9f78c2365614497475d9/mods/python/ai/bindings.nix#L644
  groq = pkgs.python311.pkgs.buildPythonPackage {
    pname = "groq";
    version = "0.9.0";
    pyproject = true;

    src = pkgs.fetchFromGitHub {
      owner = "groq";
      repo = "groq-python";
      rev = "8bcc29478315e59c2a9a730ade712511e0540f7b";
      sha256 = "sha256-WQJg/I0+tK2KtG1Vs5TiLRjji1wUATVwJ1XHuwrr5FI=";
    };

    nativeBuildInputs = with pkgs.python311.pkgs; [
      hatchling
      hatch-fancy-pypi-readme
      pydantic
    ];
    propagatedBuildInputs = with pkgs.python311.pkgs; [
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

  llm-groq = pkgs.python311.pkgs.buildPythonPackage {
    pname = "llm-groq";
    version = "0.4";
    pyproject = true;

    src = pkgs.fetchFromGitHub {
      owner = "angerman";
      repo = "llm-groq";
      rev = "fca3e1566bbc7dc8e0468c657e9fe1762cb135d0"; # v0.4
      sha256 = "sha256-wbycnUPIPBw9/HQuAa9dxMV/KfMx9v5MzY9JwueLs9M=";
    };

    propagatedBuildInputs = [ groq ];
    build-system = with pkgs.python311.pkgs; [
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
      home.packages = [ (pkgs.llm.withPlugins ([ llm-groq ])) ];
    };
  };

}

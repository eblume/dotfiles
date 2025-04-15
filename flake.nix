{
  description = "My system";

  # Other flakes that we want to pull from
  inputs = {

    # Used for system packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Used for MacOS system config
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Used for user packages and dotfiles
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs"; # Use system packages list for their inputs
    };

    # Personal (Private) flake config
    private_dotfiles = {
      url = "git+ssh://git@github.com/eblume/private_dotfiles";
      flake = false;
    };

    # Wallpapers
    wallpapers = {
      url = "gitlab:exorcist365/wallpapers";
      flake = false;
    };

    # Used to generate NixOS images for other platforms
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Convert Nix to Neovim config
    nix2vim = {
      url = "github:gytis-ivaskevicius/nix2vim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      # Global configuration for my systems
      globals = rec {
        user = "eblume";
        fullName = "Erich Blume";
        gitName = fullName;
        gitEmail = "725328+eblume@users.noreply.github.com";
        dotfilesRepo = "git@github.com:eblume/dotfiles.git";
      };

      # Common overlays to always use
      overlays = [
        inputs.nix2vim.overlay
      ];

      # System types to support.
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    rec {

      # Contains my full system builds, including home-manager
      # nixos-rebuild switch --flake .#tempest
      nixosConfigurations = {
        ringtail = import ./hosts/ringtail { inherit inputs globals overlays; };
      };

      # Contains my full Mac system builds, including home-manager
      # darwin-rebuild switch --flake .#lookingglass
      darwinConfigurations = {
        mouse = import ./hosts/mouse { inherit inputs globals overlays; };
        gilbert = import ./hosts/gilbert { inherit inputs globals overlays; };
        indri = import ./hosts/indri { inherit inputs globals overlays; };
        ML5Y2969QP = import ./hosts/ML5Y2969QP { inherit inputs globals overlays; };
      };

      # For quickly applying home-manager settings with:
      # home-manager switch --flake .#tempest
      homeConfigurations = {
        mouse = darwinConfigurations.mouse.config.home-manager.users."eblume".home;
        gilbert = darwinConfigurations.gilbert.config.home-manager.users."eblume".home;
        indri = darwinConfigurations.indri.config.home-manager.users."erichblume".home;
        ML5Y2969QP = darwinConfigurations.ML5Y2969QP.config.home-manager.users."eblume".home;
        ringtail = nixosConfigurations.ringtail.config.home-manager.users.${globals.user}.home;
      };

      packages =
        let
          neovim =
            system:
            let
              pkgs = import nixpkgs { inherit system overlays; };
            in
            import ./modules/common/neovim/package {
              inherit pkgs;
              colors = (import ./colorscheme/gruvbox-dark).dark;
            };
        in
        {
          # Package Neovim config into standalone package
          x86_64-linux.neovim = neovim "x86_64-linux";
          x86_64-darwin.neovim = neovim "x86_64-darwin";
          aarch64-linux.neovim = neovim "aarch64-linux";
          aarch64-darwin.neovim = neovim "aarch64-darwin";
        };

      # Programs that can be run by calling this flake
      apps = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system overlays; };
        in
        import ./apps { inherit pkgs; }
      );

      # Development environments
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system overlays; };
        in
        {

          # Used to run commands and edit files in this repo
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              git
              stylua
              nixfmt-rfc-style
              shfmt
              shellcheck
            ];
          };
        }
      );

      checks = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system overlays; };
        in
        {
          neovim =
            pkgs.runCommand "neovim-check-health" { buildInputs = [ inputs.self.packages.${system}.neovim ]; }
              ''
                mkdir -p $out
                export HOME=$TMPDIR
                nvim -c "checkhealth" -c "write $out/health.log" -c "quitall"

                # Check for errors inside the health log
                if $(grep "ERROR" $out/health.log); then
                  cat $out/health.log
                  exit 1
                fi
              '';
        }
      );

      formatter = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system overlays; };
        in
        pkgs.nixfmt-rfc-style
      );

      # Templates for starting other projects quickly
      templates = rec {
        default = basic;
        basic = {
          path = ./templates/basic;
          description = "Basic program template";
        };
        poetry = {
          path = ./templates/poetry;
          description = "Poetry template";
        };
        python = {
          path = ./templates/python;
          description = "Legacy Python template";
        };
        haskell = {
          path = ./templates/haskell;
          description = "Haskell template";
        };
        rust = {
          path = ./templates/rust;
          description = "Rust template";
        };
      };
    };
}

{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl-gtk-on-nix = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    prismlauncher = {
      url = "github:Diegiwg/PrismLauncher-Cracked";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      globals = {
        username = "kaori";
        hostname = "shirayuki";
        system = "x86_64-linux";
        theme = "everforest";
      };
    in
    {
      nixosConfigurations = {
        ${globals.hostname} = nixpkgs.lib.nixosSystem {
          modules = [
            inputs.aagl-gtk-on-nix.nixosModules.default
            inputs.disko.nixosModules.disko
            inputs.flake-programs-sqlite.nixosModules.programs-sqlite
            inputs.home-manager.nixosModules.home-manager
            inputs.impermanence.nixosModules.impermanence
            inputs.stylix.nixosModules.stylix

            ./modules/nixos
            ./hardware-configuration.nix

            {
              home-manager = {
                sharedModules = [
                  inputs.nixcord.homeModules.nixcord
                  inputs.nixvim.homeModules.nixvim
                  inputs.spicetify-nix.homeManagerModules.default
                  inputs.zen-browser.homeModules.beta
                ];

                users.${globals.username} = ./modules/home;
              };
            }
          ];

          specialArgs = { inherit inputs outputs globals; };
        };

        shirayuki-live = nixpkgs.lib.nixosSystem {
          modules = [
            (
              {
                modulesPath,
                outputs,
                pkgs,
                ...
              }:
              {
                imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix") ];

                environment.systemPackages = [
                  pkgs.tlp

                  outputs.packages.${globals.system}.neovim
                ];

                networking = {
                  hostName = "shirayuki";
                  networkmanager.enable = true;
                };

                nix.settings.experimental-features = [
                  "flakes"
                  "nix-command"
                ];

                nixpkgs.hostPlatform.system = "x86_64-linux";

                programs.fish.enable = true;

                system.stateVersion = "26.05";

                users.defaultUserShell = pkgs.fish;
              }
            )
          ];

          specialArgs = { inherit inputs outputs; };
        };
      };

      packages.${globals.system}.neovim =
        inputs.nixvim.legacyPackages.${globals.system}.makeNixvim
          ./modules/nixvim;
    };
}

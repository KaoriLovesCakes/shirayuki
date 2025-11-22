{
  description = "My NixOS config.";

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

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
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

    zen-browser-flake = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    globals = {
      username = "kaori";
      hostname = "shirayuki";
      system = "x86_64-linux";
      theme = "everforest";
      wallpaperUrl = "https://box.apeiros.xyz/public/everforest_walls/nature/forest_stairs.jpg";
    };
  in {
    nixosConfigurations.${globals.hostname} = nixpkgs.lib.nixosSystem {
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
              inputs.plasma-manager.homeModules.plasma-manager
              inputs.spicetify-nix.homeManagerModules.default
              inputs.nixvim.homeModules.nixvim
            ];
            users.${globals.username} = ./modules/home;
          };
        }
      ];

      specialArgs = {inherit inputs outputs globals;};
    };

    packages.${globals.system}.neovim =
      inputs.nixvim.legacyPackages.${globals.system}.makeNixvim ./modules/nixvim;

    templates.python = {
      path = ./templates/python;
      description = "Python template.";
    };
  };
}

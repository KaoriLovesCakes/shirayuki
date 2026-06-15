{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
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
      # inputs.nixpkgs.follows = "nixpkgs";
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

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    discord-latex = {
      url = "github:BinaryQuantumSoul/discord-latex";
      flake = false;
    };

    everforest-walls = {
      url = "github:Apeiros-46B/everforest-walls";
      flake = false;
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
            ./common
            ./specific
          ];

          specialArgs = {
            inherit inputs globals;
          };
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
                imports = [
                  (modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix")
                ];

                environment = {
                  variables.EDITOR = "nvim";
                  systemPackages = [
                    pkgs.tlp
                    pkgs.wezterm
                    pkgs.yazi

                    outputs.packages.${globals.system}.neovim
                  ];
                };

                networking = {
                  hostName = "shirayuki-live";
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

          specialArgs = {
            inherit outputs;
          };
        };
      };

      packages.${globals.system}.neovim =
        inputs.nixvim.legacyPackages.${globals.system}.makeNixvim
          ./nixvim;
    };
}

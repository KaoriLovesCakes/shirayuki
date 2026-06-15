{
  globals,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.default
    inputs.stylix.nixosModules.stylix

    ./impermanence.nix
    ./stylix.nix
    ./virtualisation.nix
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    newcomputermodern
    source-han-sans
    source-han-serif
    udev-gothic-nf
  ];

  hardware = {
    bluetooth.enable = true;
    graphics.enable = true;
  };

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit globals inputs pkgs;
    };
    sharedModules = [
      inputs.nixcord.homeModules.nixcord
      inputs.nixvim.homeModules.nixvim
      inputs.zen-browser.homeModules.beta
    ];
    useGlobalPkgs = true;
    users.${globals.username} = ./home;
  };

  i18n = {
    extraLocales = [
      "ja_JP.UTF-8/UTF-8"
    ];
    extraLocaleSettings.LC_TIME = "ja_JP.UTF-8";
  };

  networking = {
    hostName = globals.hostname;
    networkmanager.enable = true;
  };

  nix = {
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
    ];
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      connect-timeout = 0;
      experimental-features = [
        "flakes"
        "nix-command"
      ];
    };
  };

  nixpkgs = {
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "cloudflare-warp"
        "discord"
        "nvidia-persistenced"
        "nvidia-settings"
        "nvidia-x11"
        "osu-lazer-bin"
        "steam"
        "steam-unwrapped"
      ];
    overlays = [
      inputs.nix-alien.overlays.default
      inputs.nix-vscode-extensions.overlays.default
      inputs.nur.overlays.default
    ];
  };

  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    command-not-found.dbPath =
      lib.mkForce
        inputs.flake-programs-sqlite.packages.${globals.system}.programs-sqlite;
    fish.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    ssh.startAgent = true;
    steam.enable = true;
    uwsm.enable = true;
  };

  security.sudo.extraConfig = ''
    Defaults passwd_timeout=0
  '';

  services = {
    # automatic-timezoned.enable = true;
    displayManager.ly.enable = true;
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    tailscale.enable = true;
    xserver.enable = true;
  };

  system.stateVersion = "26.05";

  systemd = {
    packages = with pkgs; [
      cloudflare-warp
    ];
    targets.multi-user.wants = [ "warp-svc.service" ];
  };

  time.timeZone = "Europe/Paris";

  users = {
    defaultUserShell = pkgs.fish;
    # mutableUsers = false;
    users.${globals.username} = {
      isNormalUser = true;
      hashedPassword = "$y$j9T$.eqQuzOn.D9fDXJoe6ElL0$579hL7vAS.m3CfXBtPOntHjItj0u1cB1GBBTzGKqL14";
      extraGroups = [
        "docker"
        "input"
        "networkmanager"
        "uinput"
        "video"
        "wheel"
      ];
    };
  };
}

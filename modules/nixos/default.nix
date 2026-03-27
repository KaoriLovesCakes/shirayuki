{
  globals,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./disk.nix
    ./stylix.nix
    ./virtualisation.nix
  ];

  fonts.packages = with pkgs; [
    feather
    nerd-fonts.jetbrains-mono
    newcomputermodern
    source-han-sans
    source-han-serif
    udev-gothic-nf
  ];

  hardware = {
    bluetooth.enable = true;
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      open = true;
      powerManagement.enable = true;
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        offload.enable = true;
      };
    };
  };

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit globals inputs pkgs; };
    useGlobalPkgs = true;
  };

  i18n = {
    extraLocales = [ "ja_JP.UTF-8/UTF-8" ];
    extraLocaleSettings.LC_TIME = "ja_JP.UTF-8";
  };

  networking = {
    hostName = globals.hostname;
    networkmanager.enable = true;
  };

  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    optimise.automatic = true;
    settings = lib.recursiveUpdate {
      auto-optimise-store = true;
      connect-timeout = 0;
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      trusted-users = [
        "root"
        globals.username
      ];
    } inputs.aagl-gtk-on-nix.nixConfig;
  };

  nixpkgs = {
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        # "cloudflare-warp"
        "discord"
        "nvidia-persistenced"
        "nvidia-settings"
        "nvidia-x11"
        "osu-lazer-bin"
        "spotify"
        "steam"
        "steam-unwrapped"
      ];
    overlays = [
      inputs.nix-alien.overlays.default
      inputs.nix-vscode-extensions.overlays.default
      inputs.nur.overlays.default
      inputs.prismlauncher.overlays.default
    ];
  };

  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    command-not-found.enable = true;
    fish.enable = true;
    # honkers-railway-launcher.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "daily";
        extraArgs = "--keep-since 3d";
      };
      flake = "/home/${globals.username}/Repositories/${globals.hostname}";
    };
    partition-manager.enable = true;
    ssh.startAgent = true;
    steam.enable = true;
    uwsm.enable = true;
  };

  security.sudo.extraConfig = ''
    Defaults passwd_timeout=0
  '';

  services = {
    displayManager.ly.enable = true;
    automatic-timezoned.enable = true;
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
    xserver = {
      enable = true;
      videoDrivers = [
        "modesetting"
        "nvidia"
      ];
    };
  };

  system.stateVersion = "26.05";

  users = {
    defaultUserShell = pkgs.fish;
    mutableUsers = false;
    users.${globals.username} = {
      isNormalUser = true;
      hashedPassword = "$y$j9T$BGckLddbijqsTyDxP4FZT0$L6Uapd.npeyzbJbbk2p7JqLHoYLUwc8ToxWJyOI9xy1";
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

{
  config,
  globals,
  inputs,
  lib,
  pkgs,
  ...
}: {
  systemd.user.services.orca.wantedBy = lib.mkForce [];

  imports = [
    # ./cloudflare-warp.nix
    ./disk.nix
    ./stylix.nix
    ./virtualisation.nix
  ];

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.newcomputermodern
    pkgs.source-han-sans
    pkgs.source-han-serif
  ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit globals inputs pkgs;};
    useGlobalPkgs = true;
  };

  i18n = {
    extraLocaleSettings.LC_TIME = "ja_JP.UTF-8";
    inputMethod = {
      enable = true;
      fcitx5 = {
        addons = [
          pkgs.fcitx5-bamboo
          pkgs.fcitx5-mozc
        ];
        settings = {
          globalOptions = {
            "Hotkey/TriggerKeys"."0" = "";
            "Hotkey/AltTriggerKeys"."0" = "";
          };
          inputMethod = {
            "Groups/0" = {
              "Default Layout" = "us-altgr-intl";
              DefaultIM = "keyboard-us-altgr-intl";
              Name = "Default";
            };
            "Groups/0/Items/0".Name = "keyboard-us-altgr-intl";
            "Groups/0/Items/1".Name = "mozc";
            "Groups/0/Items/2".Name = "bamboo";
          };
        };
        waylandFrontend = true;
      };
      type = "fcitx5";
    };
  };

  networking = {
    hostName = globals.hostname;
    networkmanager = {
      enable = true;
      insertNameservers = ["8.8.8.8" "8.8.4.4"];
    };
  };

  nix = {
    optimise.automatic = true;
    settings =
      lib.recursiveUpdate {
        auto-optimise-store = true;
        connect-timeout = 0;
        experimental-features = [
          "flakes"
          "nix-command"
        ];
        trusted-users = ["root" globals.username];
      }
      inputs.aagl-gtk-on-nix.nixConfig;
  };

  nixpkgs = {
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        # "cloudflare-warp"
        "discord"
        "minecraft-server"
        "nvidia-persistenced"
        "nvidia-settings"
        "nvidia-x11"
        "osu-lazer-bin"
        "spotify"
        "steam"
        "steam-unwrapped"
        "vscode"
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
    honkers-railway-launcher.enable = true;
    partition-manager.enable = true;
    ssh.startAgent = true;
    steam.enable = true;
    nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "daily";
        extraArgs = "--keep-since 3d";
      };
      flake = "/home/${globals.username}/Repositories/${globals.hostname}";
    };
  };

  security.sudo.extraConfig = ''
    Defaults passwd_timeout=0
  '';

  services = {
    desktopManager.plasma6.enable = true;
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
      videoDrivers = ["nvidia"];
    };
  };

  system.stateVersion = "25.05";

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

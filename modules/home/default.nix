{
  inputs,
  pkgs,
  globals,
  ...
}: {
  imports = [
    ./kanata
    ./plasma
    ./typst
    # ./cloudflare-warp.nix
    ./discord.nix
    ./ollama.nix
    ./polybar.nix
    ./qbittorrent.nix
    ./rclone.nix
    ./stylix.nix
  ];

  home = {
    packages = [
      inputs.zen-browser-flake.packages.${globals.system}.default
      pkgs.anki-bin
      pkgs.blahaj
      pkgs.cachix
      pkgs.caprine
      pkgs.devenv
      pkgs.fastfetch
      pkgs.fd
      pkgs.hyfetch
      pkgs.mpv
      pkgs.nix-output-monitor
      pkgs.nix-tree
      pkgs.obs-studio
      pkgs.osu-lazer-bin
      pkgs.p7zip
      pkgs.prismlauncher
      pkgs.progress
      pkgs.qbittorrent
      pkgs.ripgrep
      pkgs.unp
      pkgs.unrar-wrapper
      pkgs.wl-clipboard
    ];
    stateVersion = "25.05";
    inherit (globals) username;
  };

  programs = {
    btop.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };

    home-manager.enable = true;

    # firefox = {
    #   enable = true;
    #   profiles.default.extensions.packages = [
    #     pkgs.nur.repos.rycee.firefox-addons.tridactyl
    #   ];
    # };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
      '';
    };

    fzf = {
      enable = true;
      defaultOptions = ["--color=16"];
    };

    git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
        user = {
          email = "self.bqnguyen@gmail.com";
          name = "KaoriLovesCakes";
        };
      };
    };

    hyfetch = {
      enable = true;
      settings = {
        preset = "transgender";
        mode = "rgb";
        light_dark = "dark";
        lightness = 0.65;
        color_align = {
          mode = "horizontal";
          custom_colors = [];
          fore_back = null;
        };
        backend = "fastfetch";
        args = null;
        distro = null;
        pride_month_shown = [];
        pride_month_disable = false;
      };
    };

    mpv.enable = true;

    nixvim = {
      imports = [../nixvim];
      enable = true;
      colorschemes.base16 = {
        enable = true;
        colorscheme = globals.theme;
      };
      defaultEditor = true;
    };

    spicetify = {
      enable = true;
      enabledExtensions = let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${globals.system};
      in [
        spicePkgs.extensions.keyboardShortcut
        spicePkgs.extensions.popupLyrics
      ];
    };

    starship = {
      enable = true;
      settings = (
        builtins.removeAttrs (
          builtins.fromTOML (
            builtins.readFile "${pkgs.starship}/share/starship/presets/plain-text-symbols.toml"
          )
        ) ["\"$schema\""]
      );
    };

    ssh.matchBlocks."*".addKeysToAgent = "yes";

    vscode = {
      enable = true;
      profiles.default = {
        extensions = [
          pkgs.vscode-extensions.charliermarsh.ruff
          pkgs.vscode-extensions.mechatroner.rainbow-csv
          pkgs.vscode-extensions.mkhl.direnv
          pkgs.vscode-extensions.ms-python.python
          pkgs.vscode-extensions.ms-toolsai.jupyter
          pkgs.vscode-extensions.ms-toolsai.jupyter-renderers
          pkgs.vscode-extensions.tailscale.vscode-tailscale
          pkgs.nix-vscode-extensions.open-vsx.jeanp413.open-remote-ssh
        ];
        userSettings = {
          "direnv.path.executable" = "${pkgs.direnv}/bin/direnv";
          "editor.formatOnSave" = true;
          "notebook.defaultFormatter" = "ms-python.python";
          "notebook.formatOnSave.enabled" = true;
          "window.titleBarStyle" = "custom";
          "workbench.editor.empty.hint" = "hidden";
        };
      };
      mutableExtensionsDir = false;
      package = pkgs.vscodium;
    };

    wezterm = {
      enable = true;
      extraConfig = ''
        return {
          default_cursor_style = "SteadyBar",
          enable_tab_bar = false,
          font = require("wezterm").font_with_fallback({
            "JetBrainsMonoNL NFM",
            "Source Han Sans",
          }),
          harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
        }
      '';
    };

    yazi = {
      enable = true;
      settings.manager.show_hidden = true;
    };
  };
}

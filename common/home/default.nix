{
  config,
  globals,
  pkgs,
  ...
}:
{
  imports = [
    ./discord.nix
    ./hypr.nix
    ./qbittorrent.nix
    ./rclone.nix
    ./spotify.nix
    ./stylix.nix
    ./typst.nix
  ];

  home = {
    inherit (globals) username;

    packages = with pkgs; [
      bluetui
      brightnessctl
      cloudflare-warp
      devenv
      nix-tree
      openutau
      osu-lazer-bin
      p7zip
      ryubing
      wl-clipboard

      (anki.withAddons (
        with ankiAddons;
        [
          anki-connect
        ]
      ))
    ];
    sessionVariables.NIXOS_OZONE_WL = 1;
    stateVersion = "26.05";
  };

  i18n.inputMethod = {
    enable = true;
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-bamboo
        fcitx5-mozc
      ];
      settings = {
        addons.xcb.globalSection."Allow Overriding System XKB Settings" = "True";
        inputMethod = {
          "Groups/0" = {
            DefaultIM = "keyboard-us-altgr-intl";
            "Default Layout" = "us";
            Name = "Default";
          };
          "Groups/0/Items/0".Name = "keyboard-us-altgr-intl";
          "Groups/0/Items/1".Name = "bamboo";
          "Groups/0/Items/2".Name = "mozc";
        };
      };
      waylandFrontend = true;
    };
    type = "fcitx5";
  };

  programs = {
    btop.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };

    home-manager.enable = true;

    fastfetch.enable = true;

    fd.enable = true;

    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
      '';
    };

    fzf = {
      enable = true;
      defaultOptions = [
        "--color=16"
      ];
    };

    gh.enable = true;

    git = {
      enable = true;
      settings = {
        commit.gpgsign = true;
        user = {
          email = "claire.ngoclinh@gmail.com";
          name = "KaoriLovesCakes";
          signingkey = "50984FC2662DFA3C";
        };
      };
    };

    gpg = {
      enable = true;
    };

    hyfetch = {
      enable = true;
      settings = {
        args = null;
        backend = "fastfetch";
        color_align = {
          custom_colors = [ ];
          mode = "horizontal";
          fore_back = null;
        };
        distro = null;
        light_dark = "dark";
        lightness = 0.65;
        mode = "rgb";
        preset = "transgender";
        pride_month_disable = false;
        pride_month_shown = [ ];
      };
    };

    mpv.enable = true;

    nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "daily";
        extraArgs = "--keep-since 3d";
      };
      flake = "/home/${globals.username}/Development/${globals.hostname}";
    };

    nixvim = {
      imports = [
        ../../nixvim
      ];

      enable = true;
      colorschemes.base16 = {
        enable = true;
        colorscheme = globals.theme;
      };
      defaultEditor = true;
      lsp.servers.nixd.config.settings.nixd.options =
        let
          flake = config.programs.nh.flake;
        in
        {
          home_manager.expr = ''(builtins.getFlake "${flake}").nixosConfigurations.shirayuki.options.home-manager.users.type.getSubOptions []'';
          nixos.expr = ''(builtins.getFlake "${flake}").nixosConfigurations.shirayuki.options'';
        };
      nixpkgs.config.allowUnfree = true;
    };

    obs-studio.enable = true;

    password-store.enable = true;

    ripgrep.enable = true;

    starship = {
      enable = true;
      settings = (
        removeAttrs (fromTOML (
          builtins.readFile "${pkgs.starship}/share/starship/presets/plain-text-symbols.toml"
        )) [ ''"$schema"'' ]
      );
    };

    vscodium = {
      enable = true;
      profiles.default = {
        extensions =
          (with pkgs.vscode-extensions; [
            charliermarsh.ruff
            mechatroner.rainbow-csv
            mkhl.direnv
            ms-python.python
            ms-toolsai.jupyter
            ms-toolsai.jupyter-renderers
            tailscale.vscode-tailscale
          ])
          ++ (with pkgs.nix-vscode-extensions.open-vsx; [
            detachhead.basedpyright
            jeanp413.open-remote-ssh
          ]);
        keybindings = [
          {
            key = "tab";
            command = "selectNextSuggestion";
            when = "suggestWidgetVisible && textInputFocus";
          }
          {
            key = "shift+tab";
            command = "selectPrevSuggestion";
            when = "suggestWidgetVisible && textInputFocus";
          }
        ];
        userSettings = {
          "basedpyright.analysis.typeCheckingMode" = "standard";
          "direnv.path.executable" = "${pkgs.direnv}/bin/direnv";
          "editor.formatOnSave" = true;
          "notebook.defaultFormatter" = "detachhead.basedpyright";
          "notebook.formatOnSave.enabled" = true;
          "window.titleBarStyle" = "custom";
          "workbench.editor.empty.hint" = "hidden";
        };
      };
      mutableExtensionsDir = false;
      # package = pkgs.vscodium;
    };

    waybar = {
      enable = true;
      settings.default = {
        layer = "top";
        margin = "16px 16px 0";
        modules-left = [
          "hyprland/workspaces"
          "tray"
        ];
        modules-center = [
          "custom/lyrics"
        ];
        modules-right = [
          "pulseaudio"
          "pulseaudio/slider"
          "temperature"
          "battery"
          "clock#date"
          "clock#time"
        ];
        battery = {
          format = "{icon} {capacity}%";
          format-icons = {
            charging = [
              "󰢜"
              "󰂆"
              "󰂇"
              "󰂈"
              "󰢝"
              "󰂉"
              "󰢞"
              "󰂊"
              "󰂋"
              "󰂅"
            ];
            default = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
          };
        };
        "clock#date" = {
          actions = {
            on-click = "shift_reset";
            on-scroll-down = "shift_down";
            on-scroll-up = "shift_up";
          };
          calendar = {
            format = {
              months = "<span color='#83c092'><b>{}</b></span>";
              today = "<span color='#83c092'><b>{}</b></span>";
              weekdays = "<span color='#83c092'><b>{}</b></span>";
            };
            iso8601 = true;
          };
          interval = 1;
          format = "󰃭 {:L%Y年%m月%d日 (%a)}";
          tooltip-format = "<span font-family='UDEV Gothic NF'>{calendar}</span>";
        };
        "clock#time" = {
          interval = 1;
          format = "󰥔 {:%H:%M}";
          tooltip = false;
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 0%";
          format-icons = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
          on-scroll-down = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          on-scroll-up = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        };
        temperature = {
          format = "{icon} {temperatureC}°C";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        tray.spacing = 16;
        "custom/lyrics" = {
          exec = "${pkgs.waybar-lyric}/bin/waybar-lyric --quiet";
          format = "󰝚 {0}";
          hide-empty-text = true;
          on-click = "${pkgs.waybar-lyric}/bin/waybar-lyric play-pause";
          return-type = "json";
        };
      };
      style = ''
        * {
          border-radius: 0;
          color: @base06;
          font-family: JetBrainsMonoNL Nerd Font, UDEV Gothic NF;
          font-size: 16px;
          min-height: 0;
        }

        window#waybar {
          background: alpha(@base00, 0.8);
        }

        .module {
          margin: 0 16px;
        }

        #pulseaudio {
          margin-right: 0;
        }

        #pulseaudio-slider {
          margin-left: 0;
          min-width: 128px;
          min-height: 4px;
        }

        #pulseaudio-slider highlight {
          background: @base0C;
          min-height: 4px;
        }

        #pulseaudio-slider slider {
          background: transparent;
          box-shadow: none;
          min-height: 4px;
        }

        #pulseaudio-slider trough {
          background: @base02;
        }

        #workspaces button.active,
        #workspaces button:hover {
          background: alpha(@base0C, 0.2);
        }

        #custom-lyrics {
          color: @base0C;
        }

        #custom-lyrics.paused {
          color: @base06;
        }
      '';
      systemd.enable = true;
    };

    wezterm = {
      enable = true;
      extraConfig = ''
        return {
          default_cursor_style = "SteadyBar",
          enable_tab_bar = false,
          font = require("wezterm").font_with_fallback({
            "JetbrainsMonoNL Nerd Font",
            "UDEV Gothic NF",
          }),
          harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
        }
      '';
    };

    wofi = {
      enable = true;
      settings = {
        lines = 8;
        term = "wezterm";
        width = "25%";
      };
      style = ''
        * {
          border-radius: 0;
        }
      '';
    };

    yazi.enable = true;

    zathura = {
      enable = true;
      options.selection-clipboard = "clipboard";
    };

    zen-browser.enable = true;
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-qt;
    };
    pass-secret-service.enable = true;
    shikane = {
      enable = true;
      package = (
        pkgs.rustPlatform.buildRustPackage {
          name = "shikane";
          version = "1.0.1";
          src = pkgs.fetchFromGitLab {
            owner = "w0lff";
            repo = "shikane";
            rev = "v1.0.1";
            hash = "sha256-Chc1+JUHXzuLl26NuBGVxSiXiaE4Ns1FXb0dBs6STVk=";
          };
          cargoHash = "sha256-eVEfuX/dNFoNH9o18fIx51DP/MWrQMqInU4wtGCmUbQ=";
        }
      );
      settings.profile = [
        {
          exec = [
            "hyprctl dispatch workspace 1"
          ];
          name = "undocked";
          output = [
            {
              search = "/eDP*";
              enable = true;
            }
          ];
        }
        {
          exec = [
            "hyprctl dispatch workspace 1"
          ];
          name = "docked";
          output = [
            {
              search = "/eDP*";
              enable = false;
            }
            {
              search = "/DP*";
              enable = true;
            }
          ];
        }
      ];
    };
  };

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}

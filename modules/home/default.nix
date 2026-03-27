{
  config,
  globals,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./typst
    ./discord.nix
    ./hypr.nix
    ./kanata.nix
    ./rclone.nix
    ./stylix.nix
    ./superseedr.nix
  ];

  home = {
    inherit (globals) username;

    packages = with pkgs; [
      anki-bin
      bluetui
      brightnessctl
      devenv
      fd
      nix-output-monitor
      nix-tree
      obs-studio
      osu-lazer-bin
      p7zip
      # prismlauncher
      ripgrep
      wl-clipboard
    ];
    stateVersion = "26.05";
  };

  i18n = {
    inputMethod = {
      enable = true;
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-bamboo
          fcitx5-mozc
        ];
        settings = {
          inputMethod = {
            "Groups/0" = {
              DefaultIM = "keyboard-us-altgr-intl";
              "Default Layout" = "us";
              Name = "Default";
            };
            "Groups/0/Items/0".Name = "keyboard-us-altgr-intl";
            "Groups/0/Items/1".Name = "keyboard-gr";
            "Groups/0/Items/2".Name = "bamboo";
            "Groups/0/Items/3".Name = "mozc";
          };
        };
        waylandFrontend = true;
      };
      type = "fcitx5";
    };
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

    # firefox = {
    #   enable = true;
    #   profiles.default.extensions.packages = [
    #     nur.repos.rycee.firefox-addons.tridactyl
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
      defaultOptions = [ "--color=16" ];
    };

    gh.enable = true;

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
          custom_colors = [ ];
          fore_back = null;
        };
        backend = "fastfetch";
        args = null;
        distro = null;
        pride_month_shown = [ ];
        pride_month_disable = false;
      };
    };

    iamb = {
      enable = true;
      settings = {
        default_profile = "default";
        profiles.default.user_id = "@kaorilovescakes:matrix.org";
        settings.notifications.enabled = true;
      };
    };

    mpv.enable = true;

    nixvim = {
      imports = [ ../nixvim ];
      enable = true;
      colorschemes.base16 = {
        enable = true;
        colorscheme = globals.theme;
      };
      defaultEditor = true;
    };

    spicetify = {
      enable = true;
      enabledExtensions = with inputs.spicetify-nix.legacyPackages.${globals.system}.extensions; [
        keyboardShortcut
        popupLyrics
      ];
    };

    starship = {
      enable = true;
      settings = (
        removeAttrs (fromTOML (
          builtins.readFile "${pkgs.starship}/share/starship/presets/plain-text-symbols.toml"
        )) [ "\"$schema\"" ]
      );
    };

    ssh.matchBlocks."*".addKeysToAgent = "yes";

    vscode = {
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
          ++ (with pkgs.nix-vscode-extensions; [
            open-vsx.jeanp413.open-remote-ssh
          ]);
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

    waybar = {
      enable = true;
      settings.default = {
        layer = "top";
        margin = "16px 16px 0";

        modules-left = [
          "hyprland/workspaces"
          "tray"
        ];
        modules-center = [ "custom/lyrics" ];
        modules-right = [
          "pulseaudio"
          "pulseaudio/slider"
          "battery"
          "clock#date"
          "clock#time"
        ];

        battery = {
          format = "{icon} {capacity}%";
          format-icons = [
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
        "clock#date" = {
          calendar.format = {
            weekdays = "{: %W}";
          };
          interval = 1;
          format = "󰃭 {:L%Y年%m月%d日 (%a)}";
          tooltip-format = "{calendar}";
        };
        "clock#time" = {
          interval = 1;
          format = "󰥔 {:%H:%M}";
          tooltip = false;
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 0%";
          format-icons.default = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
          on-scroll-down = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          on-scroll-up = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
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

        window {
          opacity: 0.9;
        }
      '';
    };

    yazi.enable = true;

    zathura.enable = true;

    zen-browser.enable = true;
  };

  services.kanshi = {
    enable = true;
    settings = [
      {
        profile = {
          exec = [ "hyprctl dispatch workspace 1" ];
          name = "undocked";
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              scale = 1.0;
            }
          ];
        };
      }
      {
        profile = {
          exec = [ "hyprctl dispatch workspace 1" ];
          name = "docked";
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "DP-3";
              status = "enable";
              scale = 1.0;
            }
          ];
        };
      }
    ];
  };

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}

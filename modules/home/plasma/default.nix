{
  globals,
  pkgs,
  ...
}: {
  home = {
    file.".config/kwinoutputconfig.json".source = ./kwinoutputconfig.json;
    packages = [pkgs.kdePackages.krohnkite];
  };

  programs.plasma = {
    enable = true;
    overrideConfig = true;

    configFile = {
      kded5rc.Module-gtkconfig.autoload = false;
      kdeglobals.General = {
        TerminalApplication = "wezterm";
        TerminalService = "wezterm.desktop";
      };
      kwinrc = {
        Effect-slide = {
          HorizontalGap = 0;
          SlideBackground = false;
          VerticalGap = 0;
        };
        Plugins.krohnkiteEnabled = true;
        Script-krohnkite = {
          screenGapBetween = 12;
          screenGapBottom = 12;
          screenGapLeft = 12;
          screenGapRight = 12;
          screenGapTop = 12;
        };
        Wayland.InputMethod = "/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop";
        Windows = {
          DelayFocusInterval = 0;
          FocusPolicy = "FocusFollowsMouse";
        };
        Xwayland.Scale = 1;
      };
      okularrc = {
        General = {
          LockSidebar = true;
          ShowSidebar = false;
        };
        MainWindow = {
          MenuBar = "Disabled";
          ToolBarsMovable = "Disabled";
        };
      };
    };

    input.keyboard.numlockOnStartup = "on";
    kscreenlocker.autoLock = false;

    kwin = {
      effects.desktopSwitching.animation = "slide";
      tiling.padding = 4;
      virtualDesktops = {
        number = 4;
        rows = 2;
      };
    };

    panels = [
      {
        floating = true;
        hiding = "autohide";
      }
    ];

    powerdevil.AC = {
      autoSuspend.action = "nothing";
      dimDisplay.enable = false;
      turnOffDisplay.idleTimeout = "never";
    };

    shortcuts = {
      ksmserver."Lock Session" = [];
      kwin = {
        "KrohnkiteFocusDown" = "Meta+J";
        "KrohnkiteFocusLeft" = "Meta+H";
        "KrohnkiteFocusRight" = "Meta+L";
        "KrohnkiteFocusUp" = "Meta+K";
        "Switch One Desktop Down" = "Meta+Alt+J";
        "Switch One Desktop Up" = "Meta+Alt+K";
        "Switch One Desktop to the Left" = "Meta+Alt+H";
        "Switch One Desktop to the Right" = "Meta+Alt+L";
        "Window One Desktop Down" = "Meta+Alt+Shift+J";
        "Window One Desktop Up" = "Meta+Alt+Shift+K";
        "Window One Desktop to the Left" = "Meta+Alt+Shift+H";
        "Window One Desktop to the Right" = "Meta+Alt+Shift+L";
      };
      "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" = [];
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = [];
    };

    window-rules = [
      {
        description = "Global";
        match = {
          window-class = {
            value = ".*";
            type = "regex";
          };
        };
        apply = {
          minsize = {
            value = "1,1";
            apply = "force";
          };
          noborder = {
            value = true;
            apply = "force";
          };
        };
      }
    ];

    workspace.clickItemTo = "select";
  };

  systemd.user.services.ksshaskpass-start = {
    Install.WantedBy = ["plasma-workspace.target"];
    Service = {
      ExecStart = ''
        ${
          pkgs.writeShellScript "ksshaskpass-start" ''
            #!${pkgs.bash}/bin/bash

            SSH_ASKPASS=${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass ${pkgs.openssh}/bin/ssh-add < /dev/null
            ${pkgs.openssh}/bin/ssh-add /home/${globals.username}/.ssh/id_ed25519
          ''
        }
      '';
      Restart = "on-failure";
    };
    Unit = {
      After = ["plasma-workspace.target"];
      Description = "Starts ksshaskpass.";
    };
  };
}

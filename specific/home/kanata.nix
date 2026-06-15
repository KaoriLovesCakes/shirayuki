{
  pkgs,
  ...
}:
{
  systemd.user.services.kanata = {
    Install.WantedBy = [
      "default.target"
    ];
    Service = {
      ExecStart =
        let
          bash = "${pkgs.bash}/bin/bash";
          fcitx5-remote = "${pkgs.qt6Packages.fcitx5-with-addons}/bin/fcitx5-remote";
          grep = "${pkgs.gnugrep}/bin/grep";

          cfg = pkgs.writeText "config.kbd" ''
            (defcfg
              danger-enable-cmd     yes
              linux-dev-names-exclude "AT Translated Set 2 keyboard"
              process-unmapped-keys yes
            )

            (defvar
              tap-time  150
              hold-time 150
            )

            (defsrc
              caps rsft rctl
            )

            (defvirtualkeys
              jp (cmd ${bash} -c "${fcitx5-remote} -n | ${grep} -q 'keyboard-us-altgr-intl' && ${fcitx5-remote} -s mozc || ${fcitx5-remote} -s keyboard-us-altgr-intl")
              vn (cmd ${bash} -c "${fcitx5-remote} -n | ${grep} -q 'keyboard-us-altgr-intl' && ${fcitx5-remote} -s bamboo || ${fcitx5-remote} -s keyboard-us-altgr-intl")
            )

            (defalias
              xctl (tap-hold $tap-time $hold-time (tap-dance $tap-time (esc caps)) lctl)

              jp (tap-hold $tap-time $hold-time
                (tap-dance $tap-time (rsft (on-press tap-virtualkey jp)))
                rsft
              )

              vn (tap-hold $tap-time $hold-time
                (tap-dance $tap-time (rctl (on-press tap-virtualkey vn)))
                rctl
              )
            )

            (deflayer base
              @xctl @jp @vn
            )
          '';
        in
        "${pkgs.kanata-with-cmd}/bin/kanata --cfg ${cfg}";
      Restart = "on-failure";
      RestartSec = "5";
    };
    Unit.Description = "Run kanata";
  };
}

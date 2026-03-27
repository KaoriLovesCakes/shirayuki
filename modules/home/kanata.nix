{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [ kanata-with-cmd ];

  systemd.user.services.kanata = {
    Install.WantedBy = [ "default.target" ];
    Service = {
      ExecStart =
        let
          bash = "${pkgs.bash}/bin/bash";
          fcitx5-remote = "${pkgs.qt6Packages.fcitx5-with-addons}/bin/fcitx5-remote";
          grep = "${pkgs.gnugrep}/bin/grep";

          cfg = pkgs.writeText "config.kbd" ''
            (defcfg
              danger-enable-cmd     yes
              process-unmapped-keys yes
            )

            (defvar
              tap-time  150
              hold-time 150
            )

            (defsrc
              grv     1       2       3       4       5       6       7       8       9       0       -       =
              tab     q       w       e       r       t       y       u       i       o       p       [       ]
              caps    a       s       d       f       g       h       j       k       l       ;       '       ret
              lsft            z       x       c       v       b       n       m       ,       .       /       rsft
                                                             spc                              rctl
            )

            (defvirtualkeys
              jp (cmd ${bash} -c "${fcitx5-remote} -n | ${grep} -q 'keyboard-us-altgr-intl' && ${fcitx5-remote} -s mozc || ${fcitx5-remote} -s keyboard-us-altgr-intl")
              vn (cmd ${bash} -c "${fcitx5-remote} -n | ${grep} -q 'keyboard-us-altgr-intl' && ${fcitx5-remote} -s bamboo || ${fcitx5-remote} -s keyboard-us-altgr-intl")
              gr_on (cmd ${bash} -c "${fcitx5-remote} -n > /tmp/kanata && ${fcitx5-remote} -s keyboard-gr")
              gr_off (cmd ${bash} -c "${fcitx5-remote} -s $(cat /tmp/kanata)")
            )

            (defalias
              xctl (tap-hold $tap-time $hold-time (tap-dance $tap-time (esc caps)) lctl)

              jp (tap-hold $tap-time $hold-time
                (tap-dance $tap-time (lsft (on-press tap-virtualkey jp)))
                lsft
              )

              vn (tap-hold $tap-time $hold-time
                (tap-dance $tap-time (rsft (on-press tap-virtualkey vn)))
                rsft
              )

              gr (multi
                (on-press tap-virtualkey gr_on)
                (on-release tap-virtualkey gr_off)
              )
            )

            (deflayer base
              grv     1       2       3       4       5       6       7       8       9       0       -       =
              tab     q       w       e       r       t       y       u       i       o       p       [       ]
              @xctl   a       s       d       f       g       h       j       k       l       ;       '       ret
              @jp             z       x       c       v       b       n       m       ,       .       /       @vn
                                                             spc                              @gr
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

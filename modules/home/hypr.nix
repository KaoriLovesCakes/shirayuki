{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      animations.workspace_wraparound = true;
      bind = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

        "SUPER, C, killactive,"
        "SUPER, F, togglefloating,"

        "SUPER, S, exec, ${pkgs.hyprshot}/bin/hyprshot --freeze --mode region"

        "SUPER, B, exec, zen-beta"
        "SUPER, R, exec, wofi --show drun"
        "SUPER, T, exec, wezterm"
      ];
      binde = [
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"

        ", XF86MonBrightnessDown, exec, brightnessctl --exponent set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl --exponent set +5%"

        "SUPER, H, movefocus, l"
        "SUPER, J, movefocus, d"
        "SUPER, K, movefocus, u"
        "SUPER, L, movefocus, r"

        "SUPER SHIFT, H, resizeactive, -64 0"
        "SUPER SHIFT, J, resizeactive, 0 64"
        "SUPER SHIFT, K, resizeactive, 0 -64"
        "SUPER SHIFT, L, resizeactive, 64 0"

        "SUPER ALT, H, workspace, e-1"
        "SUPER ALT, L, workspace, e+1"

        "SUPER ALT SHIFT, H, movetoworkspace, e-1"
        "SUPER ALT SHIFT, L, movetoworkspace, e+1"
      ];
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
      decoration.blur.enabled = false;
      dwindle.force_split = 2;
      env = [ "AQ_DRM_DEVICES, /dev/dri/card1:/dev/dri/card2" ];
      general = {
        gaps_in = 8;
        gaps_out = 16;
      };
      monitor = [
        "eDP-1, preferred, auto, auto"
        ", highrr, auto, auto, bitdepth, 10, cm, hdr, sdrbrightness, 1.2"
      ];
      workspace = [
        "1, default:true, persistent:true"
        "2, persistent:true"
        "3, persistent:true"
        "4, persistent:true"
      ];
    };
    systemd.enable = false;
  };
}

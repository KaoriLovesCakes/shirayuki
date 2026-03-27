{ pkgs, ... }:
{
  home.packages = with pkgs; [ qbittorrent ];

  systemd.user.services.qbittorrent-start = {
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${pkgs.qbittorrent}/bin/qbittorrent";
      Restart = "on-failure";
      RestartSec = "5";
    };
    Unit.Description = "Start qBittorrent.";
  };
}

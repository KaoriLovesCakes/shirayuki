{pkgs, ...}: {
  home.packages = [pkgs.qbittorrent];
  systemd.user.services.qbittorrent-start = {
    Install.WantedBy = ["default.target"];
    Service = {
      ExecStart = ''
        ${
          pkgs.writeShellScript "qbittorrent-start" ''
            #!${pkgs.bash}/bin/bash

            ${pkgs.qbittorrent}/bin/qbittorrent
          ''
        }
      '';
      Restart = "on-failure";
    };
    Unit.Description = "Starts qBittorrent.";
  };
}

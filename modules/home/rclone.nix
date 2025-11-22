{
  pkgs,
  globals,
  ...
}: {
  home.packages = [pkgs.rclone];
  systemd.user.services.rclone-mount-all = {
    Install.WantedBy = ["default.target"];
    Service = {
      Environment = ["PATH=/run/wrappers/bin/:$PATH"];
      ExecStartPre = ''
        ${pkgs.writeShellScript "rclone-mount-all-start-pre" ''
          remotes=$(${pkgs.rclone}/bin/rclone listremotes)
          for remote in $remotes;
          do
          remote_name=$(${pkgs.coreutils-full}/bin/echo "$remote" | ${pkgs.gnused}/bin/sed "s/://g")
          ${pkgs.coreutils-full}/bin/mkdir -p /home/${globals.username}/"$remote_name"
          done
        ''}
      '';
      ExecStart = ''
        ${pkgs.writeShellScript "rclone-mount-all-start" ''
          remotes=$(${pkgs.rclone}/bin/rclone listremotes)
          for remote in $remotes;
          do
          remote_name=$(${pkgs.coreutils-full}/bin/echo "$remote" | ${pkgs.gnused}/bin/sed "s/://g")
          ${pkgs.rclone}/bin/rclone --config=/home/${globals.username}/.config/rclone/rclone.conf --vfs-cache-mode writes mount "$remote" "$remote_name" &
          done
        ''}
      '';
      ExecStop = ''
        ${pkgs.writeShellScript "rclone-mount-all-stop" ''
          remotes=$(${pkgs.rclone}/bin/rclone listremotes)
          for remote in $remotes;
          do
          remote_name=$(${pkgs.coreutils-full}/bin/echo "$remote" | ${pkgs.gnused}/bin/sed "s/://g")
          /run/wrappers/bin/fusermount -u /home/${globals.username}/"$remote_name"
          done
        ''}
      '';
      Type = "forking";
    };
    Unit = {
      After = ["network-online.target"];
      Description = "Mount all rclone configs.";
    };
  };
}

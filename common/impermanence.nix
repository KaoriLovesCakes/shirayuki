{
  globals,
  pkgs,
  ...
}:
{
  boot.initrd.systemd = {
    extraBin = {
      "mkdir" = "${pkgs.coreutils}/bin/mkdir";
      "date" = "${pkgs.coreutils}/bin/date";
      "stat" = "${pkgs.coreutils}/bin/stat";
      "mv" = "${pkgs.coreutils}/bin/mv";
      "find" = "${pkgs.findutils}/bin/find";
      "btrfs" = "${pkgs.btrfs-progs}/bin/btrfs";
    };
    services.impermanence = {
      after = [
        "initrd-root-device.target"
        "local-fs-pre.target"
      ];
      before = [ "sysroot.mount" ];
      requiredBy = [ "initrd.target" ];
      requires = [ "initrd-root-device.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir /btrfs_tmp
        mount /dev/disk/by-partlabel/disk-main-root /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      '';
      unitConfig.DefaultDependencies = false;
    };
  };

  environment.persistence."/persistent" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
      "/var/lib/bluetooth"
      "/var/lib/docker"
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/lib/tailscale"
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
    ];
    users.${globals.username}.directories = [
      ".config/BetterDiscord"
      ".config/discord"
      ".config/lazyspotify"
      ".config/nix"
      ".config/rclone"
      ".local/share/Anki2"
      ".local/share/Steam"
      ".local/share/direnv"
      ".local/share/docker"
      ".local/share/fish"
      ".local/share/fonts"
      ".local/share/qBittorrent"
      ".local/share/warp"
      ".steam"
      ".zen"
      "Development"
      "Documents"
      "Downloads"
      "Library"

      {
        directory = ".gnupg";
        mode = "0700";
      }
      {
        directory = ".password-store";
        mode = "0700";
      }
      {
        directory = ".ssh";
        mode = "0700";
      }
    ];
  };
}

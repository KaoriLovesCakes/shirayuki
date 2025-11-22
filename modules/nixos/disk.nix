{
  globals,
  lib,
  ...
}: {
  boot = {
    initrd.postDeviceCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/root_vg/root /btrfs_tmp
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

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +7); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        efiSupport = true;
        device = "nodev";
      };
    };
  };

  disko.devices = {
    disk.main = {
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            name = "ESP";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          swap = {
            size = "4G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
          root = {
            name = "root";
            size = "384G";
            content = {
              type = "lvm_pv";
              vg = "root_vg";
            };
          };
        };
      };
    };
    lvm_vg = {
      root_vg = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "/root" = {
                  mountOptions = ["compress=zstd"];
                  mountpoint = "/";
                };
                "/persist" = {
                  mountOptions = ["subvol=persist" "compress=zstd" "noatime"];
                  mountpoint = "/persist";
                };
                "/nix" = {
                  mountOptions = ["subvol=nix" "compress=zstd" "noatime"];
                  mountpoint = "/nix";
                };
              };
            };
          };
        };
      };
    };
  };

  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/tailscale"
    ];
    users.${globals.username} = {
      directories = [
        ".config/BetterDiscord"
        ".config/Caprine"
        ".config/discord"
        ".config/libreoffice"
        ".config/nix"
        ".config/qBittorrent"
        ".config/rclone"
        ".config/spotify"
        ".local/share/Anki2"
        ".local/share/PrismLauncher"
        ".local/share/Steam"
        ".local/share/direnv"
        ".local/share/fish"
        ".local/share/fonts"
        ".local/share/honkers-railway-launcher"
        ".local/share/kwalletd"
        ".local/share/qBittorrent"
        ".ollama"
        ".ssh"
        ".steam"
        ".zen"
        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Notes"
        "Pictures"
        "Repositories"
        "Videos"
        "Virtualisation"
      ];
    };
  };

  fileSystems."/persist".neededForBoot = true;
}

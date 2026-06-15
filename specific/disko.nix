{
  disko.devices = {
    disk.main = {
      device = "/dev/disk/by-id/nvme-WD_PC_SN560_SDDPNQE-1T00-1102_24211S802756";
      type = "disk";
      content = {
        partitions = {
          esp = {
            name = "ESP";
            size = "1G";
            type = "EF00";
            content = {
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
              type = "filesystem";
            };
          };
          swap = {
            size = "8G";
            content = {
              resumeDevice = true;
              type = "swap";
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              subvolumes = {
                "/nix" = {
                  mountOptions = [
                    "compress=zstd"
                    "subvol=nix"
                    "noatime"
                  ];
                  mountpoint = "/nix";
                };
                "/persistent" = {
                  mountOptions = [
                    "compress=zstd"
                    "subvol=persistent"
                    "noatime"
                  ];
                  mountpoint = "/persistent";
                };
                "/root" = {
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                  mountpoint = "/";
                };
              };
              type = "btrfs";
              extraArgs = [ "-f" ];
            };
          };
        };
        type = "gpt";
      };
    };
  };

  fileSystems = {
    "/nix".neededForBoot = true;
    "/persistent".neededForBoot = true;
  };
}

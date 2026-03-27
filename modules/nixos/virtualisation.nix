{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ quickemu ];
  services.usbmuxd.enable = true;
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
}

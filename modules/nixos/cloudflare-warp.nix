{ pkgs, ... }:
{
  systemd = {
    packages = with pkgs; [ cloudflare-warp ];
    targets.multi-user.wants = [ "warp-svc.service" ];
  };
}

{pkgs, ...}: {
  home.packages = [pkgs.cloudflare-warp];
  systemd.user.targets.multi-user.Unit.Wants = ["warp-svc.service"];
}

{pkgs, ...}: {
  home.packages = [
    pkgs.kanata-with-cmd
  ];

  systemd.user.services.kanata = {
    Install.WantedBy = ["plasma-workspace.target"];
    Service = {
      Restart = "always";
      RestartSec = "5";
      ExecStart = "${pkgs.kanata-with-cmd}/bin/kanata --cfg ${./config.kbd}";
    };
    Unit.Description = "Run kanata";
  };
}

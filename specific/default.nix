{
  globals,
  inputs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.default

    ./disko.nix
    ./hardware-configuration.nix
  ];

  console = {
    earlySetup = true;
    useXkbConfig = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = true;
    prime = {
      nvidiaBusId = "PCI:64:0:0";
      amdgpuBusId = "PCI:65:0:0";
      offload.enable = true;
    };
  };

  home-manager.users.${globals.username} = ./home;

  services = {
    asusd.enable = true;
    auto-cpufreq = {
      enable = true;
      settings.battery = {
        enable_thresholds = true;
        energy_performance_preference = "power";
        start_threshold = 20;
        stop_threshold = 60;
        turbo = "never";
      };
    };
    xserver = {
      videoDrivers = [
        "amdgpu"
        "nvidia"
      ];
      xkb = {
        layout = "us,fr";
        options = "grp:ctrl_shift_toggle";
      };
    };
  };
}

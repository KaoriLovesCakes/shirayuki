{pkgs, ...}: {
  home.packages = [pkgs.ollama];
  services.ollama.enable = true;
}

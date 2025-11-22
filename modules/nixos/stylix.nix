{
  globals,
  lib,
  pkgs,
  ...
}: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${globals.theme}.yaml";
    fonts = {
      sizes = {
        desktop = 11;
        popups = 11;
      };
      serif = {
        package = pkgs.source-han-serif;
        name = "Source Han Serif";
      };
      sansSerif = {
        package = pkgs.source-han-sans;
        name = "Source Han Sans";
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMonoNL Nerd Font";
      };
    };
    # image = pkgs.fetchurl {
    #   url = "https://raw.githubusercontent.com/linuxdotexe/nordic-wallpapers/refs/heads/master/wallpapers/ign_astronaut.png";
    #   hash = "sha256-0KP2RCkeNTYe3sf/xArmAJEcC1DF/yQJ0hIW/uR4i4Y=";
    # };
    image = pkgs.fetchurl {
      url = globals.wallpaperUrl;
      hash = "sha256-nyVKnTJB50e1BOxj76yd32fj9+yU8b75C8i+xNrK+UQ=";
    };
    opacity.terminal = 0.9;
    polarity = "dark";
    targets = {
      grub.enable = false;
      qt.platform = lib.mkForce "kde";
      spicetify.enable = false;
    };
  };
}

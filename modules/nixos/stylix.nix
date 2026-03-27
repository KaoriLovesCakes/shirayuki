{
  globals,
  pkgs,
  ...
}:
{
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
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/Apeiros-46B/everforest-walls/refs/heads/main/nature/mist_forest_1.png";
      hash = "sha256-tGudS0BU83wbBEDCBrXWk7arkce8Bf0u+fUE3cTBYZ0=";
    };
    opacity.terminal = 0.8;
    polarity = "dark";
    targets = {
      grub.enable = false;
      spicetify.enable = false;
    };
  };
}

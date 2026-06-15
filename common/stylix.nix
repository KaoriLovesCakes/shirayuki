{
  globals,
  inputs,
  pkgs,
  ...
}:
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${globals.theme}.yaml";
    fonts = {
      sizes = {
        applications = 11;
        desktop = 11;
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
    image = inputs.everforest-walls + /nature/mist_forest_1.png;
    opacity.terminal = 0.8;
    polarity = "dark";
  };
}

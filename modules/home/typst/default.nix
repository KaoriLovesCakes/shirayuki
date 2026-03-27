{
  globals,
  pkgs,
  ...
}:
{
  home = {
    file.".local/share/typst/packages/local" = {
      recursive = true;
      source = ./local;
    };
    packages = with pkgs; [ typst ];
    sessionVariables = {
      TYPST_FONT_PATHS = "/home/${globals.username}/.local/share/fonts";
      TYPST_ROOT = "/home/${globals.username}/Notes";
    };
  };
}

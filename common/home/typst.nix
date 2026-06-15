{
  globals,
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      typst
    ];
    sessionVariables = {
      TYPST_FONT_PATHS = "/home/${globals.username}/.local/share/fonts";
      TYPST_ROOT = "/home/${globals.username}/Notes";
    };
  };
}

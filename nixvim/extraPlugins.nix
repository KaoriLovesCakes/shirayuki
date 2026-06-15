{
  pkgs,
  ...
}:
{
  extraPlugins = with pkgs.vimPlugins; [
    floaterm
  ];
}

{
  pkgs,
  ...
}:
{
  extraPackages = with pkgs; [
    fixjson
    lldb
    markdownlint-cli
    nixd
    nixfmt
    ruff
    typstyle
  ];
}

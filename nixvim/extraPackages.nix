{
  pkgs,
  ...
}:
{
  extraPackages = with pkgs; [
    fixjson
    lldb
    nixd
    nixfmt
    prettier
    ripgrep
    ruff
  ];
}

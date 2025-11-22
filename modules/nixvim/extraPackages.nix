{
  lib,
  pkgs,
  ...
}: {
  extraPackages = lib.flatten [
    pkgs.alejandra
    pkgs.fixjson
    pkgs.markdownlint-cli
    pkgs.ruff
    pkgs.typstyle
    # pkgs.ghostscript
    # pkgs.imagemagick
    # pkgs.mermaid-cli
    # pkgs.tectonic
  ];
}

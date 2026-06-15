{
  lsp.servers = {
    clangd.enable = true;
    nixd = {
      enable = true;
      config.settings.nixd.nixpkgs.expr = "import <nixpkgs> {}";
    };
    pyright.enable = true;
    rust_analyzer.enable = true;
    tinymist = {
      enable = true;
      config.offset_encoding = "utf-16";
    };
  };
}

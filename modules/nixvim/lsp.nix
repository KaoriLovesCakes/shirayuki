{
  lsp.servers = {
    clangd.enable = true;
    nil_ls = {
      enable = true;
      config.nix.flake.autoArchive = true;
    };
    pyright.enable = true;
    rust_analyzer.enable = true;
    tinymist = {
      enable = true;
      config.offset_encoding = "utf-16";
    };
  };
}

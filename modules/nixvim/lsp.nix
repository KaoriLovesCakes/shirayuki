{
  lsp.servers = {
    clangd.enable = true;
    # nil_ls = {
    #   enable = true;
    #   config.nix.flake.autoArchive = true;
    # };
    nixd = {
      enable = true;
      config.settings.nixd = {
        nixpkgs.expr = "import <nixpkgs> { }";
        options = {
          nixos.expr = ''(builtins.getFlake "/home/kaori/Repositories/shirayuki").nixosConfigurations.shirayuki.options'';
          home_manager.expr = ''(builtins.getFlake "/home/kaori/Repositories/shirayuki").nixosConfigurations.shirayuki.options.home-manager.users.type.getSubOptions []'';
        };
      };
    };
    pyright.enable = true;
    rust_analyzer.enable = true;
    tinymist = {
      enable = true;
      config.offset_encoding = "utf-16";
    };
  };
}

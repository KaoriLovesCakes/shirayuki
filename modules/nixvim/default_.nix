{globals, ...}: {
  programs.nixvim = {
    imports = [
      ./modules
      {
        enable = true;
        defaultEditor = true;
      }
    ];

    colorschemes.base16 = {
      enable = true;
      colorscheme = globals.theme;
    };
  };
}

{ lib, ... }: {
  colorschemes.base16 = {
    enable = true;
    colorscheme = lib.mkDefault "nord";
  };
}

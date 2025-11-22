{lib, ...}: {
  plugins.snacks = {
    enable = true;
    settings = {
      # image = lib.nixvim.emptyTable;
      indent.animate.enabled = false;
      notifier = lib.nixvim.emptyTable;
      picker = lib.nixvim.emptyTable;
      terminal = lib.nixvim.emptyTable;
    };
  };
}

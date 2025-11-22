{lib, ...}: {
  plugins.mini = {
    enable = true;
    mockDevIcons = true;
    modules.icons = lib.nixvim.emptyTable;
  };
}

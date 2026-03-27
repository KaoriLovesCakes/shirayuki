{
  config,
  lib,
  ...
}:
{
  keymaps = [
    {
      action = "<gv";
      key = "<";
      mode = "v";
      options = {
        desc = "Indent left";
        noremap = true;
        silent = true;
      };
    }

    {
      action = ">gv";
      key = ">";
      mode = "v";
      options = {
        desc = "Indent right";
        noremap = true;
        silent = true;
      };
    }

    {
      action = "<Cmd>edit <cfile><CR>";
      key = "gf";
      mode = "n";
      options = {
        desc = "Go to file under cursor";
        noremap = true;
        silent = true;
      };
    }

    {
      action = lib.nixvim.mkRaw "require('dapui').toggle";
      key = "<Leader>d";
      mode = "n";
      options = {
        buffer = true;
        desc = "DAP UI";
        noremap = true;
      };
    }

    {
      action = "<Cmd>Oil<CR>";
      key = "<Leader>o";
      mode = "n";
      options = {
        noremap = true;
        desc = "Oil";
      };
    }

    {
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.picker.files()
        end
      '';
      key = "<Leader>pf";
      mode = "n";
      options = {
        desc = "Files";
        noremap = true;
      };
    }

    {
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.picker.lines()
        end
      '';
      key = "<Leader>pl";
      mode = "n";
      options = {
        desc = "Lines";
        noremap = true;
      };
    }

    {
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.picker.grep()
        end
      '';
      key = "<Leader>pg";
      mode = "n";
      options = {
        desc = "Grep";
        noremap = true;
      };
    }

    {
      action = lib.nixvim.mkRaw "require('floaterm').toggle";
      key = "<Leader>t";
      mode = "n";
      options = {
        desc = "Terminal";
        noremap = true;
      };
    }

    {
      action = lib.nixvim.mkRaw "require('substitute').visual";
      key = "<C-s>";
      mode = "v";
      options = {
        noremap = true;
        desc = "Substitute";
      };
    }
  ];
}

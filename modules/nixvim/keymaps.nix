{
  config,
  lib,
  ...
}: {
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
      action = lib.nixvim.mkRaw ''
        function()
          if vim.wo.conceallevel == 0 then
            vim.wo.conceallevel = 2
          else
            vim.wo.conceallevel = 0
          end
        end
      '';

      key = "<Leader>tc";
      mode = "n";
      options = {
        noremap = true;
        desc = "Toggle conceal";
      };
    }

    {
      action = lib.nixvim.mkRaw ''
        function()
          vim.diagnostic.enable(not vim.diagnostic.is_enabled())
        end
      '';
      key = "<Leader>td";
      mode = "n";
      options = {
        noremap = true;
        desc = "Toggle diagnostic";
      };
    }

    {
      action = "<Cmd>set number!<CR>";
      key = "<Leader>tn";
      mode = "n";
      options = {
        noremap = true;
        desc = "Toggle number";
      };
    }

    {
      action = "<Cmd>Oil<CR>";
      key = "<Leader>o";
      mode = "n";
      options = {
        noremap = true;
        desc = "Open Oil";
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
        noremap = true;
        desc = "Files";
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
        noremap = true;
        desc = "Lines";
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
        noremap = true;
        desc = "Grep";
      };
    }

    {
      action = lib.nixvim.mkRaw "require('floaterm').toggle";
      key = "<Leader>tt";
      mode = "n";
      options = {
        noremap = true;
        desc = "Toggle terminal";
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

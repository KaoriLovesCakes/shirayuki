{
  config,
  lib,
  ...
}:
{
  plugins = {
    better-escape.enable = true;

    blink-cmp = {
      enable = true;
      settings = {
        completion = {
          list.selection.preselect = false;
          menu.auto_show = lib.nixvim.mkRaw ''
            function(ctx)
              return ctx.mode ~= "cmdline" or not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
            end
          '';
        };
        keymap = {
          "<CR>" = [
            "accept"
            "fallback"
          ];
          "<Esc>" = [
            "hide"
            "fallback"
          ];
          "<C-k>" = [
            "select_prev"
            "fallback"
          ];
          "<C-j>" = [
            "show"
            "select_next"
            "fallback"
          ];
          "<C-h>" = [
            "snippet_backward"
            "fallback"
          ];
          "<C-l>" = [
            "snippet_forward"
            "fallback"
          ];
          "<C-space>" = [
            "show"
            "show_documentation"
            "hide_documentation"
            "fallback"
          ];
          "<C-p>" = [
            "scroll_documentation_up"
            "fallback"
          ];
          "<C-n>" = [
            "scroll_documentation_down"
            "fallback"
          ];
        };
        snippets.preset = "luasnip";
        sources.providers = {
          path.opts = {
            label_trailing_slash = false;
            trailing_slash = false;
          };
          snippets.score_offset = 0;
        };
      };
    };

    colorizer = {
      enable = true;
      settings.css = true;
    };

    comment.enable = true;

    conform-nvim = {
      enable = true;
      settings = {
        format_on_save = lib.nixvim.mkRaw "{}";
        formatters = {
          clang-format.prepend_args = [ "--style=microsoft" ];
          # prettier.prepend_args = [
          #   "--config"
          #   (builtins.toFile ".prettierrc.yaml" ''
          #     tabWidth: 4
          #     proseWrap: "always"
          #   '')
          # ];
        };
        formatters_by_ft = {
          cpp = [ "clang-format" ];
          json = [ "fixjson" ];
          # markdown = ["prettier"];
          markdown = [ "markdownlint" ];
          nix = [ "nixfmt" ];
          python = [
            "ruff_fix"
            "ruff_format"
            "ruff_organize_imports"
          ];
          rust = [ "rustfmt" ];
          typst = [ "typstyle" ];
        };
      };
    };

    dap.enable = true;

    dap-ui.enable = true;

    dap-virtual-text.enable = true;

    friendly-snippets.enable = true;

    guess-indent.enable = true;

    lspconfig.enable = true;

    lualine = {
      enable = true;
      settings = {
        options = {
          component_separators = "";
          globalstatus = true;
          theme = "base16";
          section_separators = "";
        };
        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [ "filetype" ];
          lualine_c = [
            {
              __unkeyed = "filename";
              file_status = true;
              path = 2;
            }
          ];
          lualine_x = [
            {
              __unkeyed = lib.nixvim.mkRaw "require('noice').api.statusline.mode.get";
              cond = lib.nixvim.mkRaw "require('noice').api.statusline.mode.has";
            }
            {
              __unkeyed = lib.nixvim.mkRaw ''
                function()
                  local char_count = vim.fn.wordcount().chars
                  if vim.fn.wordcount().visual_chars ~= nil then
                    char_count = vim.fn.wordcount().visual_chars
                  end

                  return tostring(char_count)
                    .. (char_count == 1 and " character" or " characters")
                end
              '';
              cond = lib.nixvim.mkRaw ''
                function()
                  return vim.bo.filetype == "markdown" or vim.bo.filetype == "text" or vim.bo.filetype == "typst" or vim.bo.filetype == ""
                end
              '';
            }
            {
              __unkeyed = lib.nixvim.mkRaw ''
                function()
                  local word_count = vim.fn.wordcount().words
                  if vim.fn.wordcount().visual_words ~= nil then
                    word_count = vim.fn.wordcount().visual_words
                  end

                  return tostring(word_count)
                    .. (word_count == 1 and " word" or " words")
                end
              '';
              cond = lib.nixvim.mkRaw ''
                function()
                  return vim.bo.filetype == "markdown" or vim.bo.filetype == "text" or vim.bo.filetype == "typst" or vim.bo.filetype == ""
                end
              '';
            }
            "location"
          ];
          lualine_y = [ "" ];
          lualine_z = [ "" ];
        };
      };
    };

    luasnip = {
      enable = true;
      fromVscode = [ { paths = ./snippets; } ];
    };

    mini = {
      enable = true;
      mockDevIcons = true;
      modules.icons = lib.nixvim.emptyTable;
    };

    noice.enable = true;

    nvim-autopairs = {
      enable = true;
      settings.checkTs = true;
    };

    nvim-surround.enable = true;

    oil.enable = true;

    render-markdown.enable = true;

    snacks = {
      enable = true;
      settings = {
        # image = lib.nixvim.emptyTable;
        indent.animate.enabled = false;
        notifier = lib.nixvim.emptyTable;
        picker = lib.nixvim.emptyTable;
      };
    };

    substitute.enable = true;

    telescope.enable = true;

    transparent.enable = true;

    treesitter = {
      enable = true;
      folding.enable = true;
      nixvimInjections = false;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
    };

    venv-selector.enable = true;

    which-key = {
      enable = true;
      settings.spec = [
        ((lib.nixvim.listToUnkeyedAttrs [ "<leader>d" ]) // { group = "Dap"; })
        ((lib.nixvim.listToUnkeyedAttrs [ "<leader>p" ]) // { group = "Pick"; })
      ];
    };
  };
}

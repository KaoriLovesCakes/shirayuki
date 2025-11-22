{
  config,
  lib,
  ...
}: {
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        component_separators = "";
        globalstatus = true;
        theme = config.colorschemes.base16.colorscheme;
        section_separators = "";
      };
      sections = {
        lualine_a = ["mode"];
        lualine_b = ["filetype"];
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
        lualine_y = [""];
        lualine_z = [""];
      };
    };
  };
}

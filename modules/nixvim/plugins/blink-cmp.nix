{lib, ...}: {
  plugins.blink-cmp = {
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
        "<CR>" = ["accept" "fallback"];
        "<Esc>" = ["hide" "fallback"];
        "<C-k>" = ["select_prev" "fallback"];
        "<C-j>" = ["show" "select_next" "fallback"];
        "<C-h>" = ["snippet_backward" "fallback"];
        "<C-l>" = ["snippet_forward" "fallback"];
        "<C-space>" = ["show" "show_documentation" "hide_documentation" "fallback"];
        "<C-p>" = ["scroll_documentation_up" "fallback"];
        "<C-n>" = ["scroll_documentation_down" "fallback"];
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
}

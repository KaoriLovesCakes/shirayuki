{lib, ...}: {
  autoCmd = [
    {
      callback = lib.nixvim.mkRaw ''
        function()
          vim.keymap.set("n", "j", "gj", { buffer = true, noremap = true })
          vim.keymap.set("n", "k", "gk", { buffer = true, noremap = true })
        end
      '';
      event = ["FileType"];
      pattern = ["markdown" "text" "types"];
    }

    {
      callback = lib.nixvim.mkRaw ''
        function()
          if vim.fn.executable("fcitx5-remote") == 1 then
            vim.fn.jobstart({"fcitx5-remote", "-s", "keyboard-us-altgr-intl"})
          end
        end
      '';
      event = ["InsertLeave"];
      pattern = ["*"];
    }

    {
      callback = lib.nixvim.mkRaw ''
        function()
          vim.keymap.set("n", "<LocalLeader>c", function()
            if require("floaterm.state").terminals then
              typst_buf = nil
              for i, v in ipairs(require("floaterm.state").terminals) do
                if v["name"] == "Typst" and not typst_buf then
                  typst_buf = v["buf"]
                  break
                end
              end

              if typst_buf then
                if not require("floaterm.state").volt_set then
                  require("floaterm").toggle()
                end
                require("floaterm.utils").switch_buf(typst_buf)
                return
              end

              require("floaterm.api").new_term({ name = "Typst" })
            end

            local cmd = string.format("typst watch %s --open", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)))
            require("floaterm.api").send_cmd({ name = "Typst", cmd = cmd })
          end, { buffer = true, desc = "Compile and watch", noremap = true })
        end
      '';
      event = ["FileType"];
      pattern = "typst";
    }
  ];
}

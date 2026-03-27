{
  lib,
  pkgs,
  ...
}:
{
  autoCmd = [
    {
      callback = lib.nixvim.mkRaw ''
        function()
          vim.keymap.set("n", "j", "gj", { buffer = true, noremap = true })
          vim.keymap.set("n", "k", "gk", { buffer = true, noremap = true })
        end
      '';
      event = [ "FileType" ];
      pattern = [
        "markdown"
        "text"
        "typst"
      ];
    }

    {
      callback = lib.nixvim.mkRaw ''
        function()
          if vim.fn.executable("fcitx5-remote") == 1 then
            vim.fn.jobstart({"fcitx5-remote", "-s", "keyboard-us-altgr-intl"})
          end
        end
      '';
      event = [ "InsertLeave" ];
      pattern = "*";
    }

    {
      callback = lib.nixvim.mkRaw ''
        function()
          local dap = require("dap")
          local dapui = require("dapui")

          dap.adapters.lldb = {
            type = "server",
            port = "''${port}",
            executable = {
              command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter}/bin/codelldb",
              args = {
                "--port",
                "''${port}",
                "--settings",
                '{ "initCommands": [ "settings set target.process.thread.step-avoid-regexp ^std::" ], "showDisassembly": "never" }'
              },
            },
          }

          dap.configurations.cpp = {
            {
              cwd = "''${workspaceFolder}",
              name = "DAP",
              type = "lldb",
              request = "launch",
              program = function()
                return vim.fn.expand('%:p:r')
              end,
              stopOnEntry = false,
            },
          }

          vim.keymap.set("n", "<LocalLeader>c", function()
            if dap.session() then
              dap.terminate()
            end

            print("Compiling...")

            local src_file = vim.fn.expand('%')
            local out_file = vim.fn.expand('%:p:r')

            vim.fn.jobstart({"g++", src_file, "-g", "-fsanitize=address,undefined", "-std=c++20", "-o", out_file}, {
              on_exit = function(_, compile_exit_code)
                vim.schedule(function()
                  if compile_exit_code == 0 then
                    print("Compiled successfully. Running...")

                    local output_lines = {}

                    vim.fn.jobstart({out_file}, {
                      stdout_buffered = true,
                      on_stdout = function(_, data)
                        print(data)
                        if data then
                          for _, line in ipairs(data) do
                            table.insert(output_lines, line)
                         end
                        end
                      end,
                      on_exit = function(_, exit_code)
                        vim.schedule(function()
                          if exit_code == 0 then
                            print("Execution succeeded.")

                            dapui.close()
                          else
                            print("Execution failed. Debugging...")

                            dapui.open()
                            dap.continue()
                          end
                        end)
                      end
                    })
                  else
                    print("Compilation failed.")
                  end
                end)
              end
            })
          end, { buffer = true, desc = "Compile and Run", noremap = true })

          vim.keymap.set("n", "<LocalLeader>i", function()
            print("Compiling...")

            local src_file = vim.fn.expand('%')
            local out_file = vim.fn.expand('%:p:r')

            vim.fn.jobstart({"g++", src_file, "-g", "-fsanitize=address,undefined", "-std=c++20", "-o", out_file}, {
              on_exit = function(_, compile_exit_code)
                vim.schedule(function()
                  if compile_exit_code == 0 then
                    print("Compiled successfully. Running...")

                    if require("floaterm.state").terminals then
                      buf = nil
                      for i, v in ipairs(require("floaterm.state").terminals) do
                        if v["name"] == "C++" and not buf then
                          buf = v["buf"]
                          break
                        end
                      end

                      if buf then
                        if not require("floaterm.state").volt_set then
                          require("floaterm").toggle()
                        end

                        require("floaterm.api").delete_term(buf)
                      end

                      require("floaterm.api").new_term({ name = "C++" })
                    end

                    require("floaterm.api").send_cmd({ name = "C++", cmd = out_file })
                  else
                    print("Compilation failed.")
                  end
                end)
              end
            })
          end, { buffer = true, desc = "Compile and Run (Interactive)", noremap = true })

          vim.keymap.set("n", "<LocalLeader>y", "<Cmd>%y<CR>", { buffer = true, desc = "Yank all", noremap = true })
        end
      '';
      event = [ "FileType" ];
      pattern = "cpp";
    }

    {
      callback = lib.nixvim.mkRaw ''
        function()
          vim.keymap.set("n", "<LocalLeader>c", function()
            if require("floaterm.state").terminals then
              buf = nil
              for i, v in ipairs(require("floaterm.state").terminals) do
                if v["name"] == "Typst" and not buf then
                  buf = v["buf"]
                  break
                end
              end

              if buf then
                if not require("floaterm.state").volt_set then
                  require("floaterm").toggle()
                end
                require("floaterm.utils").switch_buf(buf)
                return
              end

              require("floaterm.api").new_term({ name = "Typst" })
            end

            local cmd = string.format("typst watch %s --open", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)))
            require("floaterm.api").send_cmd({ name = "Typst", cmd = cmd })
          end, { buffer = true, desc = "Compile", noremap = true })
        end
      '';
      event = [ "FileType" ];
      pattern = "typst";
    }
  ];
}

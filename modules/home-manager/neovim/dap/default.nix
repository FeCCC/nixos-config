{
  lib,
  pkgs,
  ...
}:
{
  programs.nixvim = {
    plugins = {
      dap = {
        enable = true;
        adapters.servers = {
          lldb = {
            port = "$\{port\}";
            executable = {
              command = "${lib.getBin pkgs.lldb}/bin/lldb-dap";
              args = [
                "--port"
                "$\{port\}"
              ];
            };
          };
        };
        configurations = rec {
          c = [
            {
              name = "Launch file";
              type = "lldb";
              request = "launch";
              program.__raw = ''
                function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end'';
              cwd = "$\{workspaceFolder\}";
            }
          ];
          cpp = c;
          rust = c;
        };
        extensions = {
          dap-ui = {
            enable = true;
            layouts = [
              {
                elements = [
                  {
                    id = "scopes";
                    size = 0.25;
                  }
                  {
                    id = "breakpoints";
                    size = 0.25;
                  }
                  {
                    id = "stacks";
                    size = 0.25;
                  }
                  {
                    id = "watches";
                    size = 0.25;
                  }
                ];
                position = "left";
                size = 40;
              }
              {
                elements = [
                  {
                    id = "console";
                    size = 0.5;
                  }
                  {
                    id = "repl";
                    size = 0.5;
                  }
                ];
                position = "bottom";
                size = 10;
              }
            ];
          };
          dap-python.enable = true;
          dap-virtual-text.enable = true;
        };
        signs = {
          dapBreakpoint = {
            text = "";
            texthl = "DapBreakpoint";
            linehl = "DapBreakpoint";
            numhl = "DapBreakpoint";
          };
          dapBreakpointCondition = {
            text = "";
            texthl = "DapBreakpoint";
            linehl = "DapBreakpoint";
            numhl = "DapBreakpoint";
          };
          dapBreakpointRejected = {
            text = "󰅙";
            texthl = "DapBreakpint";
            linehl = "DapBreakpoint";
            numhl = "DapBreakpoint";
          };
          dapLogPoint = {
            text = "";
            texthl = "DapLogPoint";
            linehl = "DapLogPoint";
            numhl = "DapLogPoint";
          };
          dapStopped = {
            text = "";
            texthl = "DapStopped";
            linehl = "DapStopped";
            numhl = "DapStopped";
          };
        };
      };
    };
    extraConfigLua = ''
      require('dap').set_log_level("ERROR")

      require('dap').listeners.after.event_initialized['dapui_config'] = require('dapui').open
      require('dap').listeners.before.event_terminated['dapui_config'] = require('dapui').close
      require('dap').listeners.before.event_exited['dapui_config'] = require('dapui').close


      local dap_breakpoint_color = {
            breakpoint = {
                ctermbg = 0,
                fg = "#993939",
                bg = "#31353f",
            },
            logpoing = {
                ctermbg = 0,
                fg = "#61afef",
                bg = "#31353f",
            },
            stopped = {
                ctermbg = 0,
                fg = "#98c379",
                bg = "#31353f",
            },
        }

      vim.api.nvim_set_hl(0, "DapBreakpoint", dap_breakpoint_color.breakpoint)
      vim.api.nvim_set_hl(0, "DapLogPoint", dap_breakpoint_color.logpoing)
      vim.api.nvim_set_hl(0, "DapStopped", dap_breakpoint_color.stopped)
    '';
  };
}

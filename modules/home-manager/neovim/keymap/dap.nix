{
  programs.nixvim.keymaps = [
    # dap相关
    {
      action = ":lua require'dap'.continue()<CR>";
      key = "<F5>";
      mode = [ "n" ];
      options = {
        noremap = true;
        silent = true;
        desc = "dap continue";
      };
    }
    {
      action = ":lua require'dap'.toggle_breakpoint()<CR>";
      key = "<leader>b";
      mode = [ "n" ];
      options = {
        noremap = true;
        silent = true;
        desc = "dap breakpoint";
      };
    }
    {
      action = ":lua require'dap'.step_into()<CR>";
      key = "<leader>i";
      mode = [ "n" ];
      options = {
        noremap = true;
        silent = true;
        desc = "dap step into";
      };
    }
    {
      action = ":lua require'dap'.step_over()<CR>";
      key = "<leader>o";
      mode = [ "n" ];
      options = {
        noremap = true;
        silent = true;
        desc = "dap step_over";
      };
    }
  ];
}

{
  programs.nixvim.keymaps = [
    {
      action = ":NvimTreeToggle<CR>";
      key = "<A-m>";
      mode = ["n"];
    }
    {
      action = "<C-w>h";
      key = "<A-h>";
      mode = ["n"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = "<C-w>j";
      key = "<A-j>";
      mode = ["n"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = "<C-w>k";
      key = "<A-k>";
      mode = ["n"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = "<C-w>l";
      key = "<A-l>";
      mode = ["n"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    # 左右比例控制
    {
      action = ":vertical resize -2<CR>";
      key = "<C-Left>";
      mode = ["n"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = ":vertical resize +2<CR>";
      key = "<C-Right>";
      mode = ["n"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    # 上下比例
    {
      action = ":resize +2<CR>";
      key = "<C-Down>";
      mode = ["n"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = ":resize -2<CR>";
      key = "<C-Up>";
      mode = ["n"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    # 相等比例
    {
      action = "<C-w>=";
      key = "s=";
      mode = ["n"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    #bufferline相关
    {
      action = ":BufferLineCyclePrev<CR>";
      key = "<leader>h";
      mode = ["n"];
    }
    {
      action = ":BufferLineCycleNext<CR>";
      key = "<leader>l";
      mode = ["n"];
    }
    {
      action = ":BufferLinePick<CR>";
      key = "<leader>p";
      mode = ["n"];
    }
    {
      action = ":BufferLineMovePrev<CR>";
      key = "<leader>mh";
      mode = ["n"];
    }
    {
      action = ":BufferLineMoveNext<CR>";
      key = "<leader>ml";
      mode = ["n"];
    }
    {
      action = ":BufferLineCloseLeft<CR>";
      key = "<leader>ch";
      mode = ["n"];
    }
    {
      action = ":BufferLineCloseRight<CR>";
      key = "<leader>cl";
      mode = ["n"];
    }
    {
      action = ":BufferLineCloseRight<CR>:BufferLineCloseLeft<CR>";
      key = "<leader>ca";
      mode = ["n"];
    }
    #telescope相关
    {
      action = ":lua require('telescope.builtin').find_files()<CR>";
      key = "<leader>ff";
      mode = ["n"];
    }
    {
      action = ":lua require('telescope.builtin').buffers()<CR>";
      key = "<leader>fb";
      mode = ["n"];
    }
    {
      action = ":lua require('telescope.builtin').help_tags()<CR>";
      key = "<leader>fh";
      mode = ["n"];
    }
    {
      action = ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>";
      key = "<leader>fg";
      mode = ["n"];
    }
    {
      action = "<cmd>GrepInDirectory<CR>";
      key = "<leader>fd";
      mode = ["n"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = ":lua require('telescope').extensions.projects.projects()<CR>";
      key = "<leader>fp";
      mode = ["n"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    #auto-session
    {
      action = ":lua require('auto-session.session-lens').search_session()<CR>";
      key = "<leader>fs";
      mode = ["n"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    # toggleterm相关
    {
      action = ":ToggleTerm direction=vertical<CR>";
      key = "\\<C-\\>";
      mode = ["n"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = ":ToggleTerm direction=float<CR>";
      key = "f<C-\\>";
      mode = ["n"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = ":ToggleTerm direction=tab<CR>";
      key = "t<C-\\>";
      mode = ["n"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = "<C-\\><C-n>";
      key = "<A-q>";
      mode = ["t"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    # Terminal相关
    {
      action = ":set splitbelow<CR>:sp | terminal<CR>";
      key = "st";
      mode = ["n"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = ":set splitright<CR>:vsp | terminal<CR>";
      key = "stv";
      mode = ["n"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = "<Cmd> wincmd l<CR>";
      key = "<A-l>";
      mode = ["t"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = "<Cmd> wincmd h<CR>";
      key = "<A-h>";
      mode = ["t"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = "<Cmd> wincmd j<CR>";
      key = "<A-j>";
      mode = ["t"];
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = "<Cmd> wincmd k<CR>";
      key = "<A-k>";
      mode = ["t"];
      options = {
        noremap = true;
        silent = true;
      };
    }
  ];
}

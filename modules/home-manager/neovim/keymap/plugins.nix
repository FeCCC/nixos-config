{
  programs.nixvim.keymaps = [
    {
      action = ":NvimTreeToggle<CR>";
      key = "<A-m>";
      mode = ["n"];
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
  ];
}

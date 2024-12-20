{
  programs.nixvim.keymaps = let
    silents = {
      noremap = true;
      silent = true;
    };
  in [
    {
      action = ":Yazi<CR>";
      key = "<A-m>";
      mode = ["n"];
    }
    {
      action = "<C-w>h";
      key = "<A-h>";
      mode = ["n"];
      options = silents;
    }
    {
      action = "<C-w>j";
      key = "<A-j>";
      mode = ["n"];
      options = silents;
    }
    {
      action = "<C-w>k";
      key = "<A-k>";
      mode = ["n"];
      options = silents;
    }
    {
      action = "<C-w>l";
      key = "<A-l>";
      mode = ["n"];
      options = silents;
    }
    # 左右比例控制
    {
      action = ":vertical resize -2<CR>";
      key = "<C-Left>";
      mode = ["n"];
      options = silents;
    }
    {
      action = ":vertical resize +2<CR>";
      key = "<C-Right>";
      mode = ["n"];
      options = silents;
    }
    # 上下比例
    {
      action = ":resize +2<CR>";
      key = "<C-Down>";
      mode = ["n"];
      options = silents;
    }
    {
      action = ":resize -2<CR>";
      key = "<C-Up>";
      mode = ["n"];
      options = silents;
    }
    # 相等比例
    {
      action = "<C-w>=";
      key = "s=";
      mode = ["n"];
      options = silents;
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
      options = silents;
    }
    {
      action = ":lua require('telescope').extensions.projects.projects()<CR>";
      key = "<leader>fp";
      mode = ["n"];
      options = silents;
    }
    #auto-session
    {
      action = ":lua require('auto-session.session-lens').search_session()<CR>";
      key = "<leader>fs";
      mode = ["n"];
      options = silents;
    }
    # toggleterm相关
    {
      action = ":ToggleTerm direction=vertical<CR>";
      key = "\\<C-\\>";
      mode = ["n"];
      options = silents;
    }
    {
      action = ":ToggleTerm direction=float<CR>";
      key = "f<C-\\>";
      mode = ["n"];
      options = silents;
    }
    {
      action = ":ToggleTerm direction=tab<CR>";
      key = "t<C-\\>";
      mode = ["n"];
      options = silents;
    }
    {
      action = "<C-\\><C-n>";
      key = "<A-q>";
      mode = ["t"];
      options = silents;
    }
    # Terminal相关
    {
      action = ":set splitbelow<CR>:sp | terminal<CR>";
      key = "st";
      mode = ["n"];
      options = silents;
    }
    {
      action = ":set splitright<CR>:vsp | terminal<CR>";
      key = "stv";
      mode = ["n"];
      options = silents;
    }
    {
      action = "<Cmd> wincmd l<CR>";
      key = "<A-l>";
      mode = ["t"];
      options = silents;
    }
    {
      action = "<Cmd> wincmd h<CR>";
      key = "<A-h>";
      mode = ["t"];
      options = silents;
    }
    {
      action = "<Cmd> wincmd j<CR>";
      key = "<A-j>";
      mode = ["t"];
      options = silents;
    }
    {
      action = "<Cmd> wincmd k<CR>";
      key = "<A-k>";
      mode = ["t"];
      options = silents;
    }
    # gitsigns 相关
    {
      action = ":Gitsigns next_hunk<CR>";
      key = "<leader>gj";
      mode = ["n"];
      options = silents;
    }
    {
      action = ":Gitsigns prev_hunk<CR>";
      key = "<leader>gk";
      mode = ["n"];
      options = silents;
    }
    {
      action = ":Gitsigns stage_hunk<CR>";
      key = "<leader>gsh";
      mode = ["n" "v"];
      options = silents;
    }
    {
      action = ":Gitsigns undo_stage_hunk<CR>";
      key = "<leader>guh";
      mode = ["n"];
      options = silents;
    }
    {
      action = ":Gitsigns reset_hunk<CR>";
      key = "<leader>grh";
      mode = ["n" "v"];
      options = silents;
    }
    {
      action = ":Gitsigns stage_buffer<CR>";
      key = "<leader>gsb";
      mode = ["n"];
      options = silents;
    }
    {
      action = ":Gitsigns reset_buffer<CR>";
      key = "<leader>grb";
      mode = ["n"];
      options = silents;
    }
    {
      action = ":Gitsigns preview_hunk<CR>";
      key = "<leader>gp";
      mode = ["n"];
      options = silents;
    }
    {
      action = ":Gitsigns blame_line<CR>";
      key = "<leader>gbl";
      mode = ["n"];
      options = silents;
    }
    {
      action = ":lua require'gitsigns'.diffthis('~')<CR>";
      key = "<leader>gdf";
      mode = ["n"];
      options = silents;
    }
    {
      action = ":Gitsigns toggle_deleted<CR>";
      key = "<leader>gdl";
      mode = ["n"];
      options = silents;
    }
  ];
}

{
  programs.nixvim.keymaps =
    let
      silents = {
        noremap = true;
        silent = true;
      };
    in
    [
      {
        action = ":Yazi<CR>";
        key = "<A-m>";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = "<C-w>h";
        key = "<A-h>";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = "<C-w>j";
        key = "<A-j>";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = "<C-w>k";
        key = "<A-k>";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = "<C-w>l";
        key = "<A-l>";
        mode = [ "n" ];
        options = silents;
      }
      # 左右比例控制
      {
        action = ":SmartResizeLeft<CR>";
        key = "<C-h>";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":SmartResizeRight<CR>";
        key = "<C-l>";
        mode = [ "n" ];
        options = silents;
      }
      # 上下比例
      {
        action = ":SmartResizeDown<CR>";
        key = "<C-j>";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":SmartResizeUp<CR>";
        key = "<C-k>";
        mode = [ "n" ];
        options = silents;
      }
      # 相等比例
      {
        action = "<C-w>=";
        key = "<leader>s=";
        mode = [ "n" ];
        options = silents;
      }
      # 交换窗口
      {
        action = ":SmartSwapRight<CR>";
        key = "<leader><leader>l";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":SmartSwapLeft<CR>";
        key = "<leader><leader>h";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":SmartSwapUp<CR>";
        key = "<leader><leader>k";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":SmartSwapDown<CR>";
        key = "<leader><leader>j";
        mode = [ "n" ];
        options = silents;
      }
      # barbar相关
      {
        action = ":BufferPrevious<CR>";
        key = "<leader>h";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":BufferNext<CR>";
        key = "<leader>l";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":BufferPick<CR>";
        key = "<leader>p";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":BufferMovePrevious<CR>";
        key = "<leader>mh";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":BufferMoveNext<CR>";
        key = "<leader>ml";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":BufferClose<CR>";
        key = "<leader>cl";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":BufferCloseAllButCurrent<CR>";
        key = "<leader>ca";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":BufferPickDelete<CR>";
        key = "<leader>cp";
        mode = [ "n" ];
        options = silents;
      }
      # tab 相关
      {
        action = ":tabprevious<CR>";
        key = "<leader>th";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":tabnext<CR>";
        key = "<leader>tl";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":tabclose<CR>";
        key = "<leader>tc";
        mode = [ "n" ];
        options = silents;
      }
      #telescope相关
      {
        action = ":lua require('telescope.builtin').find_files()<CR>";
        key = "<leader>ff";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":lua require('telescope.builtin').buffers()<CR>";
        key = "<leader>fb";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":lua require('telescope.builtin').help_tags()<CR>";
        key = "<leader>fh";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>";
        key = "<leader>fg";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = "<cmd>GrepInDirectory<CR>";
        key = "<leader>fd";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":lua require('telescope').extensions.projects.projects()<CR>";
        key = "<leader>fp";
        mode = [ "n" ];
        options = silents;
      }
      #auto-session
      {
        action = ":lua require('auto-session.session-lens').search_session()<CR>";
        key = "<leader>fs";
        mode = [ "n" ];
        options = silents;
      }
      # toggleterm相关
      {
        action = ":ToggleTerm direction=vertical<CR>";
        key = "\\<C-\\>";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":ToggleTerm direction=float<CR>";
        key = "f<C-\\>";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":ToggleTerm direction=tab<CR>";
        key = "t<C-\\>";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = "<C-\\><C-n>";
        key = "<A-q>";
        mode = [ "t" ];
        options = silents;
      }
      {
        action = "<C-\\><C-n>";
        key = "<ESC>";
        mode = [ "t" ];
        options = silents;
      }
      # # Terminal相关
      # {
      #   action = ":set splitbelow<CR>:sp | terminal<CR>";
      #   key = "<leader>st";
      #   mode = ["n"];
      #   options = silents;
      # }
      # {
      #   action = ":set splitright<CR>:vsp | terminal<CR>";
      #   key = "<leader>stv";
      #   mode = ["n"];
      #   options = silents;
      # }
      {
        action = "<Cmd> wincmd l<CR>";
        key = "<A-l>";
        mode = [ "t" ];
        options = silents;
      }
      {
        action = "<Cmd> wincmd h<CR>";
        key = "<A-h>";
        mode = [ "t" ];
        options = silents;
      }
      {
        action = "<Cmd> wincmd j<CR>";
        key = "<A-j>";
        mode = [ "t" ];
        options = silents;
      }
      {
        action = "<Cmd> wincmd k<CR>";
        key = "<A-k>";
        mode = [ "t" ];
        options = silents;
      }
      # gitsigns 相关
      {
        action = ":Gitsigns next_hunk<CR>";
        key = "<leader>gj";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":Gitsigns prev_hunk<CR>";
        key = "<leader>gk";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":Gitsigns stage_hunk<CR>";
        key = "<leader>gsh";
        mode = [
          "n"
          "v"
        ];
        options = silents;
      }
      {
        action = ":Gitsigns undo_stage_hunk<CR>";
        key = "<leader>guh";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":Gitsigns reset_hunk<CR>";
        key = "<leader>grh";
        mode = [
          "n"
          "v"
        ];
        options = silents;
      }
      {
        action = ":Gitsigns stage_buffer<CR>";
        key = "<leader>gsb";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":Gitsigns reset_buffer<CR>";
        key = "<leader>grb";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":Gitsigns preview_hunk<CR>";
        key = "<leader>gp";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":Gitsigns blame<CR>";
        key = "<leader>gbl";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":GitBlameCopySHA<CR>:DiffviewOpen <C-R>+<CR>";
        key = "<leader>gdf";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":DiffviewClose<CR>";
        key = "<leader>gdc";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":Gitsigns toggle_deleted<CR>";
        key = "<leader>gdl";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":LazyGit<CR>";
        key = "<leader>lg";
        mode = [ "n" ];
        options = silents;
      }
      {
        action = ":DiffviewFileHistory %<CR>";
        key = "<leader>gfh";
        mode = [ "n" ];
        options = silents;
      }
    ];
}

{
  programs.nixvim.plugins.bufferline = {
    enable = true;
    settings = {
      options = {
        close_command = "Bdelete! %d";
        always_show_bufferline = true;
        show_buffer_icons = true;
        show_buffer_close_icons = true;
        show_tab_indicators = true;
        persist_buffer_sort = true;
        separator_style = "slant";
        diagnostics = "nvim_lsp";
        offsets = [
          {
            filetype = "NvimTree";
            text = "🗂️ File Explorer";
            highlight = "BufferlineCustomeNvimtree";
            text_align = "left";
            separator = true;
          }
          {
            filetype = "lspsagaoutline";
            text = "🧵 outline";
            highlight = "BufferlineCustomeNvimtree";
            text_align = "right";
          }
          {
            filetype = "Outline";
            highlight = "BufferlineCustomeNvimtree";
            text = "💯 outline";
            text_align = "right";
          }
          {
            filetype = "undotree";
            highlight = "BufferlineCustomeNvimtree";
            text = "🧶 undo Tree";
            text_align = "left";
          }
        ];
        hover.enable = true;
      };
    };
  };
}

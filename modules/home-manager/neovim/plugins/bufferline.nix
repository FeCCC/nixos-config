{
  programs.nixvim.plugins.bufferline = {
    enable = true;
    settings = {
      options = {
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
        hover.enabled = true;
      };
    };
  };
}

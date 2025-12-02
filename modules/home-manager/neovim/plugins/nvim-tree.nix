{
  programs.nixvim.plugins.nvim-tree = {
    enable = false;
    settings = {
      hijackCursor = true;
      hijackNetrw = true;
      hijackUnnamedBufferWhenOpening = true;
      updateFocusedFile.enable = true;
    };

  };
}

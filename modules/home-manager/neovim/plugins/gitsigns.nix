{
  programs.nixvim.plugins.gitsigns = {
    enable = true;
    settings = {
      current_line_blame = false;
      word_diff = true;
      diff_opts = {internal = true;};
    };
  };
}

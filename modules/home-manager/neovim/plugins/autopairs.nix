{
  programs.nixvim.plugins.nvim-autopairs = {
    enable = true;
    settings = {
      check_ts = true;
      fast_wrap.chars = [
        "{"
        "["
        "("
        "\""
        "'"
      ];
    };
  };
}

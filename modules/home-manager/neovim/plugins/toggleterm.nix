{
  programs.nixvim.plugins.toggleterm = {
    enable = true;
    settings = {
      open_mapping = "[[<c-\\>]]";
    };
    # lazyLoad = {
    #   enable = true;
    #   settings = {
    #     keys = ["\\<C-\\>" "f<C-\\>" "t<C-\\>"];
    #   };
    # };
  };
}

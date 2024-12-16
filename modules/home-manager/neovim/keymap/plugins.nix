{
  programs.nixvim.keymaps = [
    {
      action = ":NvimTreeToggle<CR>";
      key = "<A-m>";
      mode = ["n"];
    }
  ];
}

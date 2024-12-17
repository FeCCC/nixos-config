{
  programs.nixvim.keymaps = [
    {
      #nvimtree-tree 切换
      action = ":NvimTreeToggle<CR>";
      key = "<A-m>";
      mode = ["n"];
    }
    {
      # 退出
      action = ":q<CR>";
      key = "<leader>q";
      mode = ["n"];
    }
    {
      # 保存退出
      action = ":wq<CR>";
      key = "<leader>wq";
      mode = ["n"];
    }
    {
      # 全部退出
      action = "::quitall<CR>";
      key = "<leader><leader><leader><leader>q";
      mode = ["n"];
    }
  ];
}

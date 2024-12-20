{
  programs.nixvim.keymaps = [
    #粘贴
    {
      action = "\"+P";
      key = "<C-v>";
      mode = ["n"];
    }
    {
      action = "<Esc>\"+P";
      key = "<C-v>";
      mode = ["i"];
    }
    #复制
    {
      action = "\"+y";
      key = "<C-c>";
      mode = ["v"];
    }
    #编辑模式退出
    {
      action = "<Esc>";
      key = "<C-c>";
      mode = ["i"];
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

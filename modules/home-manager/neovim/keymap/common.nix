{
  programs.nixvim.keymaps = [
    #粘贴
    {
      action = "\"+P";
      key = "<C-v>";
      mode = ["n"];
      options = {
        silent = true;
      };
    }
    {
      action = "<Esc>\"+P";
      key = "<C-v>";
      mode = ["i"];
      options = {
        silent = true;
      };
    }
    #复制
    {
      action = "\"+y";
      key = "<C-c>";
      mode = ["v"];
      options = {
        silent = true;
      };
    }
    #编辑模式退出
    {
      action = "<Esc>";
      key = "<C-c>";
      mode = ["i"];
      options = {
        silent = true;
      };
    }
    {
      # 退出
      action = ":q<CR>";
      key = "<leader>q";
      mode = ["n"];
      options = {
        silent = true;
      };
    }
    {
      # 保存退出
      action = ":wq<CR>";
      key = "<leader>wq";
      mode = ["n"];
      options = {
        silent = true;
      };
    }
    {
      # 全部退出
      action = "::quitall<CR>";
      key = "<leader><leader><leader><leader>q";
      mode = ["n"];
      options = {
        silent = true;
      };
    }
  ];
}

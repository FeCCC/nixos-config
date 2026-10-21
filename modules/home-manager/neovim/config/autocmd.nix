[
  {
    #退出insert模式自动保存
    command = "silent! wall";
    event = [
      "InsertLeave"
      "TextChanged"
    ];
    pattern = [
      "*"
    ];
    nested = true;
  }
  {
    # nixvim 的 treesitter 模块只支持旧版 nvim-treesitter.configs，
    # 当前 nvim-treesitter 为 main 分支，需要手动在 FileType 时启动高亮
    desc = "Enable treesitter highlighting";
    event = [ "FileType" ];
    callback.__raw = ''
      function(args)
        if vim.treesitter.highlighter.active[args.buf] then
          return
        end
        pcall(vim.treesitter.start, args.buf)
      end
    '';
  }
  # {
  #   #保存时自动格式化
  #   event = [
  #     "BufWritePre"
  #   ];
  #   pattern = [
  #     "*"
  #   ];
  #   callback.__raw = ''
  #     function()
  #       require('conform').format()
  #     end
  #   '';
  # }
]

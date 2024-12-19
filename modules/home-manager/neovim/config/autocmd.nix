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

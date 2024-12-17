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
]

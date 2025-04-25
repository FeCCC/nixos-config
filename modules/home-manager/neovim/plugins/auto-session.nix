{
  programs.nixvim.plugins.auto-session = {
    enable = true;
    settings = {
      suppressed_dirs = [
        "~/"
        "/"
        "/ect"
        "/usr"
      ]; # 打开这些目录里面的内容时，不加载会话
      auto_restore = false;
    };
  };
}

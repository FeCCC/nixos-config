{
  programs.nixvim.plugins.auto-session = {
    enable = true;
    settings = {
      suppressed_dirs = [
        "~/"
        "/"
        "/etc"
        "/usr"
      ]; # 打开这些目录里面的内容时，不加载会话
    };
  };
}

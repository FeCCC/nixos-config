{
  programs.nixvim.plugins.project-nvim = {
    enable = true;
    enableTelescope = true;
    settings = {
      patterns = [
        ".git"
        "_darcs"
        ".hg"
        ".bzr"
        ".svn"
        "Makefile"
        "package.json"
        ".sln"
        "init.lua"
      ];
    };
  };
}

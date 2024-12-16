{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./plugins
    ./keymap
    ./dependency.nix
  ];

  programs.nixvim = {
    enable = true;
    vimAlias = true;
    withNodeJs = true;
    withPerl = true;
    withPython3 = true;
    withRuby = true;

    globals = {
      encoding = "utf-8"; # 设置编码utf8
    };
    opts = {
      fileencodings = "ucs-bom ,utf-8 ,cp936 ,gb18030 ,big5 ,euc-jp ,euc-kr ,latin1"; # 设置编码自动识别
    };

    colorschemes.onedark = {
      enable = true;
      settings = {
        style = "dark";
      };
    };
    plugins = {
      lualine = {
        enable = true;
      };
    };
  };
}

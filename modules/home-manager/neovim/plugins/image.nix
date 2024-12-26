{pkgs, ...}: {
  programs.nixvim = {
    plugins.image = {
      enable = true;
    };
    extraPackages = with pkgs; [imagemagick];
  };
}

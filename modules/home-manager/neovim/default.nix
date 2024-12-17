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

    globals = import ./config/global.nix;
    opts = import ./config/opts.nix;
    autoCmd = import ./config/autocmd.nix;

    colorschemes.onedark = {
      enable = true;
      settings = {
        style = "dark";
      };
    };
  };
}

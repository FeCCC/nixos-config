{
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./plugins
    ./keymap
    ./lsp
    ./dap
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

    clipboard = {
      register = "unnamedplus";
      providers = {
        wl-copy.enable = true;
        xclip.enable = true;
        xsel.enable = true;
      };
    };
  };
}

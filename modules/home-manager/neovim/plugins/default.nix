{
  imports = [
    ./dashboard.nix
    ./nvim-tree.nix
    ./bufferline.nix
    ./telescope.nix
    ./auto-session.nix
    ./project.nix
  ];

  programs.nixvim.plugins = {
    lualine.enable = true;
    bufdelete.enable = true;
    lz-n.enable = true;
    which-key.enable = true;
  };
}

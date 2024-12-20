{
  imports = [
    ./dashboard.nix
    ./nvim-tree.nix
    ./bufferline.nix
    ./telescope.nix
    ./auto-session.nix
    ./project.nix
    ./toggleterm.nix
    ./gitsigns.nix
    ./yazi.nix
  ];

  programs.nixvim.plugins = {
    indent-blankline.enable = true;
    lualine.enable = true;
    bufdelete.enable = true;
    lz-n.enable = true;
    which-key.enable = true;
    notify.enable = true;
    treesitter.enable = true;
    illuminate.enable = true;
    scrollview.enable = true;
    gitblame.enable = true;
    image.enable = true;
  };
}

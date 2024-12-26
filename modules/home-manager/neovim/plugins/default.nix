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
    ./image.nix
  ];

  programs.nixvim.plugins = {
    indent-blankline.enable = true;
    lualine.enable = true;
    lz-n.enable = true;
    which-key.enable = true;
    notify.enable = true;
    noice.enable = true;
    treesitter.enable = true;
    illuminate.enable = true;
    scrollview.enable = true;
    gitblame.enable = true;
    lazygit.enable = true;
    diffview.enable = true;
    git-conflict.enable = true;
    leap.enable = true;
  };
}

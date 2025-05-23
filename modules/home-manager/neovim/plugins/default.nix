{
  imports = [
    ./dashboard.nix
    ./nvim-tree.nix
    ./barbar.nix
    ./telescope.nix
    ./auto-session.nix
    ./project.nix
    ./toggleterm.nix
    ./gitsigns.nix
    ./yazi.nix
    ./image.nix
    ./autopairs.nix
  ];

  programs.nixvim.plugins = {
    indent-blankline = {
      enable = true;
      settings.exclude.filetypes = [ "dashboard" ];
    };
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
    rainbow-delimiters.enable = true;
    treesitter-context.enable = true;
    smart-splits.enable = true;
    fzf-lua.enable = true;
  };
}

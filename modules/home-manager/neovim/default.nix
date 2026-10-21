{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
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

    nixpkgs.config.allowUnfree = true;

    globals = import ./config/global.nix;
    opts = import ./config/opts.nix;
    autoCmd = import ./config/autocmd.nix;

    # Neovim 默认不会把 docker-compose 文件识别成 yaml.docker-compose，
    # 导致 docker_compose_language_service 永远不 attach
    filetype.pattern = {
      "docker%-compose.*%.ya?ml" = "yaml.docker-compose";
      "compose.*%.ya?ml" = "yaml.docker-compose";
    };

    # colorschemes.onedark = {
    #   enable = true;
    #   settings = {
    #     style = "dark";
    #   };
    # };

    clipboard = {
      register = "unnamedplus"; # 使用系统剪贴板
      providers = {
        wl-copy.enable = true;
        xclip.enable = true;
        xsel.enable = true;
      };
    };

    extraPlugins = [ pkgs.vimPlugins.onedarkpro-nvim ];
    extraConfigLua = ''
      vim.cmd("colorscheme onedark")
      -- yaml.docker-compose 复用 yaml 的 parser 和 queries
      vim.treesitter.language.register("yaml", "yaml.docker-compose")
    '';
  };
}

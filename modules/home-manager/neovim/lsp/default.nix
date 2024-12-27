{
  imports = [
    ./lspsaga.nix
    ./cmp.nix
    ./conform.nix
  ];

  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      servers = {
        clangd.enable = true;
        lua_ls.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
          installRustfmt = true;
        };
        pylyzer.enable = true;
        jsonls.enable = true;
        yamlls.enable = true;
        bashls.enable = true;
        nil_ls.enable = true;
        html.enable = true;
        ts_ls.enable = true;
        docker_compose_language_service.enable = true;
        nginx_language_server.enable = true;
      };
    };
    trouble.enable = true;
  };
}

{
  lib,
  pkgs,
  ...
}: {
  programs.nixvim.plugins.conform-nvim = {
    enable = true;
    settings = {
      formatters_by_ft = {
        nix = ["alejandra"];
        python = ["black"];
        lua = ["stylua"];
      };
      default_format_opts = {
        async = true;
        lsp_format = "fallback";
      };
      formatters = {
        black = {command = "${lib.getExe pkgs.black}";};
        isort = {command = "${lib.getExe pkgs.isort}";};
        alejandra = {command = "${lib.getExe pkgs.alejandra}";};
        stylua = {command = "${lib.getExe pkgs.stylua}";};
      };
    };
  };
}

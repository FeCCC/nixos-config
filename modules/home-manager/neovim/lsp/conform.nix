{
  lib,
  pkgs,
  ...
}:
{
  programs.nixvim.plugins.conform-nvim = {
    enable = true;
    settings = {
      formatters_by_ft = {
        nix = [ "nixfmt" ];
        python = [ "black" ];
        lua = [ "stylua" ];
        beancount = [ "bean-format" ];
        "*" = [ "trim_whitespace" ];
      };
      default_format_opts = {
        async = true;
        lsp_format = "fallback";
      };
      formatters = {
        black = {
          command = "${lib.getExe pkgs.black}";
        };
        isort = {
          command = "${lib.getExe pkgs.isort}";
        };
        nixfmt = {
          command = "${lib.getExe pkgs.nixfmt-rfc-style}";
        };
        stylua = {
          command = "${lib.getExe pkgs.stylua}";
        };
        bean-format = {
          command = "${lib.getBin pkgs.beancount}/bin/bean-format";
        };
      };
    };
  };
}

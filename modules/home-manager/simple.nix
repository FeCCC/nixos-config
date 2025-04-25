{
  lib,
  pkgs,
  ...
}:
let
  apps = import ../common/apps.nix;
in
{
  programs = lib.genAttrs apps.home (app: {
    enable = true;
  });

  home.packages = map (app: pkgs.${app}) apps.pkgs;
}

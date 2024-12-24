{
  inputs,
  lib,
  pkgs,
  ...
}: let
  apps = import ../common/apps.nix;
in {
  programs = lib.genAttrs apps.nixos (app: {
    enable = true;
  });

  environment.systemPackages = map (app: pkgs.${app}) apps.pkgs;
}

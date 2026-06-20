{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.my_config.desktop;
  subModules = [
    ./programs.nix
    ./dms.nix
    ./niri.nix
  ];
  load = file: import file { inherit lib pkgs inputs; };
in
{
  options.my_config.desktop.enable = lib.mkEnableOption "use desktop";

  imports = [
    inputs.niri.homeModules.niri
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
  ];

  config = lib.mkIf cfg.enable (lib.mkMerge (map load subModules));
}

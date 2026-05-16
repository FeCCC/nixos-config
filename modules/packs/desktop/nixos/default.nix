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
    ./dms.nix
    ./niri.nix
    ./fonts.nix
    ./packages.nix
  ];
  load = file: import file { inherit pkgs inputs; };
in
{
  options.my_config.desktop.enable = lib.mkEnableOption "use desktop";

  imports = [
    inputs.dms.nixosModules.dank-material-shell
    inputs.dms.nixosModules.greeter
  ];

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home-manager.sharedModules = [
        { my_config.desktop.enable = true; }
      ];
    })
    (lib.mkIf cfg.enable (lib.mkMerge (map load subModules)))
  ];
}

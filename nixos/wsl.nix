{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];
  options = {
    isWsl = lib.mkEnableOption "open wsl";
  };

  config = lib.mkIf config.isWsl {
    wsl = {
      enable = true;
      defaultUser = "miku";
    };
  };
}

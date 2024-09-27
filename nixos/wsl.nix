{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  wsl = {
    enable = true;
    defaultUser = "miku";
  };

  networking.hostName = "nixos-wsl";
}

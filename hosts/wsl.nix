{
  config,
  pkgs,
  lib,
  ...
}: {
  isWsl = true;
  networking.hostName = "nixos-wsl";
}

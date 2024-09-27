{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  networking.hostName = "nixos";

  boot.loader.grub.device = "nodev";

  usedocker = true;
}

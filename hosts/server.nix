{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  networking.hostName = "nixos-server";

  boot.loader.grub.device = "nodev";

  my_config.docker.enable = true;
  my_config.desktop.enable = false;
}

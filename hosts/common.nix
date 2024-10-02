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

  my_config.docker.enable = true;
  my_config.desktop.enable = true;
}

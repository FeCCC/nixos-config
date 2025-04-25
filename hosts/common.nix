{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  networking.hostName = "nixos";

  boot.loader.grub.device = "nodev";

  my_os_config.docker.enable = true;
  my_os_config.desktop.enable = true;
}

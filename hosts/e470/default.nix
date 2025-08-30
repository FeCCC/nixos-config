{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-ThinkPad-E470";

  my_os_config.docker.enable = true;
  my_os_config.desktop.enable = true;

}

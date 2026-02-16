{
  inputs,
  modulesPath,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ./hardware-configuration.nix
  ];

  nix.settings = {
    sandbox = false;
  };

  proxmoxLXC = {
    privileged = true;
    manageNetwork = true;
    manageHostName = true;
  };

  networking.hostName = "docker";

  my_config.docker.enable = true;
  my_config.desktop.enable = false;
  my_config.netdata.enable = true;
}

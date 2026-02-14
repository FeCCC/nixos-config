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
  ];

  nix.settings = {
    sandbox = false;
  };

  proxmoxLXC = {
    privileged = true;
    manageNetwork = true;
    manageHostName = true;
  };

  networking.hostName = "nixos-docker";

  my_config.docker.enable = true;
  my_config.desktop.enable = false;

}

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "mikoto";
  networking.hostId = "ce43dac1"; # ZFS 要求

  # ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = true;

  # systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = lib.mkForce false;

  # Headless server
  my_config.desktop.enable = false;
  my_config.docker.enable = true;
  my_config.netdata.enable = true;

  nixpkgs.hostPlatform = "x86_64-linux";
}

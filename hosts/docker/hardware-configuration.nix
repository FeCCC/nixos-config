{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{

  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true; # needed for NFS

  fileSystems = {
    "/mnt/NAS/docker" = {
      device = "truenas.local:/mnt/NAS/docker";
      fsType = "nfs";
    };
    "/mnt/NAS/docker-storage" = {
      device = "truenas.local:/mnt/NAS/docker-storage";
      fsType = "nfs";
    };
    "/mnt/NAS/share" = {
      device = "truenas.local:/mnt/NAS/share";
      fsType = "nfs";
    };
  };
}

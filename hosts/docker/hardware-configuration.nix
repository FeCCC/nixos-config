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

  systemd.services.docker = {
    # 'requires' 表示强依赖：如果挂载失败，Docker 不会启动
    requires = [
      "mnt-NAS-docker.mount"
      "mnt-NAS-docker\\x2dstorage.mount"
      "mnt-NAS-share.mount"
    ];
  };
}

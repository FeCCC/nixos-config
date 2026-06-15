{
  lib,
  config,
  ...
}:
{
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = true;

  fileSystems."/" = {
    device = "rpool/local/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/E301-5ED0";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/data/appdata" = {
    device = "rpool/appdata";
    fsType = "zfs";
  };

  # 快照管理
  services.sanoid = {
    enable = true;
    interval = "*:0/10"; # 每 10 分钟触发
    templates."default" = {
      frequent_period = 10; # 每10分钟
      frequently = 12; # 保留12个 = 2h
      hourly = 48; # 保留48个 = 2d
      daily = 14; # 保留14个 = 2w
      weekly = 4; # 保留4个 = 1m
      monthly = 12; # 保留12个 = 1y
      autoprune = true;
    };
    datasets."rpool" = {
      useTemplate = [ "default" ];
      recursive = true;
    };
  };

  sops.templates."syncoid-ssh-key" = {
    content = config.sops.placeholder.id_rsa_default;
    # path = "/run/secrets/syncoid-ssh-key";
    owner = "syncoid";
    mode = "0600";
  };

  # 发送到 TrueNAS
  services.syncoid = {
    enable = true;
    interval = "*-*-* *:2/10"; # 每10分钟的快照拍完后2分钟发送（02,12,22...）
    # user = "root"; # 用你的用户，省得配 sudo
    sshKey = config.sops.templates.syncoid-ssh-key.path;
    commonArgs = [
      # "--sshoption=UserKnownHostsFile=/dev/null"
      # "--sshoption=StrictHostKeyChecking=no"
      "--sshoption=StrictHostKeyChecking=accept-new"
    ];
    commands."appdata-to-truenas" = {
      source = "rpool/appdata";
      target = "miku@truenas.local:NAS/appdata/mikoto";
      extraArgs = [ "--no-sync-snap" ]; # 不额外创建同步快照，用 sanoid 已有的
      # service = {
      #   serviceConfig = {
      #     # 覆盖默认的 true，允许读 /root
      #     ProtectHome = lib.mkForce "read-only";
      #     # 把 ~/.ssh 加进 chroot 命名空间
      #     BindReadOnlyPaths = [
      #       "/root/.ssh"
      #     ];
      #   };
      # };
    };
  };
}

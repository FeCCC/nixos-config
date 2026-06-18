{
  pkgs,
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
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
      "nofail"
    ];
  };

  fileSystems."/data/appdata" = {
    device = "rpool/appdata";
    fsType = "zfs";
  };
  environment.systemPackages = [ pkgs.efibootmgr ];

  boot.loader.systemd-boot.extraInstallCommands = ''
    BOOT_DEV=$(findmnt -n -o SOURCE /boot)
    if echo "$BOOT_DEV" | grep -q sda1; then
      TARGET=/dev/sdb1
      TARGET_DISK=/dev/sdb
      TARGET_PART=1
    elif echo "$BOOT_DEV" | grep -q sdb1; then
      TARGET=/dev/sda1
      TARGET_DISK=/dev/sda
      TARGET_PART=1
    else
      echo "Unknown boot device: $BOOT_DEV" >&2
      exit 0
    fi
    if [ -b "$TARGET" ]; then
      mount "$TARGET" /mnt
      rsync -a --delete /boot/ /mnt/
      bootctl install --esp-path=/mnt
      efibootmgr -c -d "$TARGET_DISK" -p "$TARGET_PART" -L "NixOS (fallback)" || true
      umount /mnt
    fi
  '';

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
    owner = "syncoid";
    mode = "0600";
  };

  # 发送到 TrueNAS
  services.syncoid = {
    enable = true;
    interval = "*-*-* *:2/10"; # 每10分钟的快照拍完后2分钟发送（02,12,22...）
    sshKey = config.sops.templates.syncoid-ssh-key.path;
    commonArgs = [
      "--sshoption=StrictHostKeyChecking=accept-new"
    ];
    commands."appdata-to-truenas" = {
      source = "rpool/appdata";
      target = "miku@truenas.local:NAS/appdata/mikoto";
      extraArgs = [ "--no-sync-snap" ]; # 不额外创建同步快照，用 sanoid 已有的
    };
  };
}

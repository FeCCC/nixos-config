# router 硬件占位 —— 不是真机值。
# 装机时用 nixos-generate-config 生成的内容整体替换本文件。build 通过 ≠ 能开机：
# 下面的设备名和分区都是猜的。
{
  nixpkgs.hostPlatform = "x86_64-linux";

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos"; # 占位
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP"; # 占位
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
}

{
  config,
  lib,
  ...
}:
lib.mkMerge [
  {
    fileSystems."/" = {
      device = "/dev/sda1";
      fsType = "ext4";
    };

    nixpkgs.hostPlatform = "x86_64-linux";
  }
  (lib.mkIf config.my_config.desktop.enable {
    services.xserver.videoDrivers = [
      "nvidia"
      "modesetting"
      "intel"
      "fbdev"
    ];
    hardware.graphics.enable = true;
    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
    };
  })
]

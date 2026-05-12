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
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  })
]

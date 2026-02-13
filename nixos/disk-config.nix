# Example to create a bios compatible gpt partition
{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
  ];
  options.my_config.install.enable = lib.mkEnableOption "install on new machine";

  config = lib.mkIf config.my_config.install.enable {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/sda";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                name = "boot";
                size = "1M";
                type = "EF02";
              };
              ESP = {
                size = "500M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # Override existing partition
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}

# This is just an example, you should generate yours with nixos-generate-config and put it in here.
{
  lib,
  ...
}:
{
  # boot.loader.systemd-boot.enable = true;

  fileSystems."/" = lib.mkDefault {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

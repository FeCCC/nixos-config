# This is just an example, you should generate yours with nixos-generate-config and put it in here.
{
  # boot.loader.systemd-boot.enable = true;

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

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

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = "x86_64-linux";
}

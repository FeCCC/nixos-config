{
  lib,
  ...
}:
{
  imports = [
    ./hardware
    ./hush.nix
  ];

  networking.hostName = "mikoto";
  networking.hostId = "ce43dac1"; # ZFS 要求
  # ComfyUI端口
  networking.firewall.allowedTCPPorts = [ 8188 ];

  # systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = lib.mkForce false;

  my_config.desktop.enable = false;
  my_config.docker.enable = true;
  my_config.netdata.enable = true;
  my_config.hermes-agent.enable = true;

  nixpkgs.hostPlatform = "x86_64-linux";
}

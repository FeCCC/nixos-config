
{ lib, ... }:
{
  imports = [
    ./hardware.nix
    ./net.nix
    ./wan.nix
    ./ipv6-pd.nix
    ./mihomo.nix
    ./dns.nix
    ./tunnels.nix
    ./admin.nix
  ];

  networking.hostName = "router";

  # 避免 NetworkManager 接管网卡并顶掉静态地址
  networking.networkmanager.enable = lib.mkForce false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  my_config.desktop.enable = false;
  my_config.docker.enable = false;
  my_config.hermes-agent.enable = false;
}

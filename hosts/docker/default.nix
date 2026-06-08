{
  inputs,
  modulesPath,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ./hardware-configuration.nix
  ];

  nix.settings = {
    sandbox = false;
  };

  proxmoxLXC = {
    privileged = true;
    manageNetwork = true;
    manageHostName = true;
  };

  networking.hostName = "docker";
  networking.firewall.allowedTCPPorts = [
    8096 # jellyfin
    21115 # rustdesk NAT 类型测试
    21116 # rustdesk ID 服务器
    21117 # rustdesk 中继服务器
    21118 # rustdesk Web 控制台
  ];
  networking.firewall.allowedUDPPorts = [
    21116 # rustdesk ID 服务器
  ];
  networking.wireless.enable = lib.mkForce false;

  my_config.docker.enable = true;
  my_config.desktop.enable = false;
  my_config.netdata.enable = true;
  my_config.i2pd.enable = false;
  my_config.hermes-agent.enable = true;

  services.syncthing.enable = lib.mkForce false;

  virtualisation.docker.daemon.settings = {
    bip = "10.254.1.1/24";
    default-address-pools = [
      {
        base = "10.254.0.0/16";
        size = 28;
      }
    ];
  };
}

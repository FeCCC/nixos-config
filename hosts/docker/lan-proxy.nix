{
  config,
  ...
}:
{
  # 内网 443 入口：容器收下内网请求，补 PROXY 协议头后回连本机 443。
  # 容器与宿主之间走一条私有 veth；内网设备访问容器地址时由本机代答 ARP 并转发。
  boot.kernel.sysctl."net.ipv4.conf.eth0.proxy_arp" = 1;

  # 这条 veth 由容器模块自己创建和配置，别让 NetworkManager 接管（否则会刷掉地址和路由）
  networking.networkmanager.unmanaged = [ "interface-name:ve-lan-proxy" ];

  networking.firewall.trustedInterfaces = [ "ve-lan-proxy" ];
  networking.firewall.extraForwardRules = ''
    iifname "eth0" oifname "ve-lan-proxy" accept
    iifname "ve-lan-proxy" oifname "eth0" accept
  '';

  containers.lan-proxy = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.200.200.1";
    localAddress = "192.168.200.200";

    config = { ... }: {
      networking.firewall.allowedTCPPorts = [ 443 ];

      services.haproxy = {
        enable = true;
        config = ''
          defaults
              mode tcp
              timeout connect 5s
              timeout client 10m
              timeout server 10m
          frontend lan_https
              bind *:443
              default_backend upstream
          backend upstream
              server upstream 10.200.200.1:443 send-proxy-v2
        '';
      };

      systemd.services.haproxy = {
        unitConfig.StartLimitIntervalSec = 0;
        serviceConfig.RestartSec = 5;
      };

      system.stateVersion = "26.05";
    };
  };
}

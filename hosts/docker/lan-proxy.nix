{
  config,
  ...
}:
{
  # 内网入口：容器收下内网请求后按端口转发回宿主；80 与 443 补 PROXY 协议头，其余端口原样直连。
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
      networking.firewall.allowedTCPPorts = [
        80
        443
        25
        465
        993
        995
        222
      ];

      services.haproxy = {
        enable = true;
        config = ''
          defaults
              mode tcp
              timeout connect 5s
              timeout client 10m
              timeout server 10m

          frontend lan_80
              bind *:80
              default_backend be_80
          backend be_80
              server host 10.200.200.1:80 send-proxy-v2

          frontend lan_443
              bind *:443
              default_backend be_443
          backend be_443
              server host 10.200.200.1:443 send-proxy-v2

          frontend lan_25
              bind *:25
              default_backend be_25
          backend be_25
              server host 10.200.200.1:25

          frontend lan_465
              bind *:465
              default_backend be_465
          backend be_465
              server host 10.200.200.1:465

          frontend lan_993
              bind *:993
              default_backend be_993
          backend be_993
              server host 10.200.200.1:993

          frontend lan_995
              bind *:995
              default_backend be_995
          backend be_995
              server host 10.200.200.1:995

          frontend lan_222
              bind *:222
              default_backend be_222
          backend be_222
              server host 10.200.200.1:222
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

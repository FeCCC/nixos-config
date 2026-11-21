# 网络基础：网桥 / 静态地址 / IPv4 转发 / NAT / nftables 策略 / 端口转发。
{ lib, ... }:
{
  # 用 networkd 管理接口，IPv6 PD 需要
  networking.useNetworkd = true;

  # 避免 resolved 占用 53 端口
  services.resolved.enable = lib.mkForce false;

  # 保持 eth* 命名，桥成员才对得上
  networking.usePredictableInterfaceNames = false;

  # eth0 只做 PPPoE 裸口，不分配地址
  networking.interfaces.eth0.useDHCP = false;

  networking.bridges.br-lan.interfaces = [
    "eth1"
    "eth2"
    "eth3"
  ];

  networking.interfaces.br-lan = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = "192.168.0.10";
        prefixLength = 16;
      }
    ];
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking.nat = {
    enable = true;
    internalInterfaces = [ "br-lan" ];
    externalInterface = "pppoe-wan";
    forwardPorts = [
      {
        sourcePort = 6881;
        destination = "192.168.42.16:6881";
        proto = "tcp";
      }
      {
        sourcePort = 6881;
        destination = "192.168.42.16:6881";
        proto = "udp";
      }
    ];
  };

  networking.nftables.enable = true;

  networking.firewall = {
    enable = true;
    # 用 ICMP/RST 拒绝，不静默丢弃
    rejectPackets = true;

    interfaces.br-lan = {
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ 67 ];
    };

    # 11010 监听在本机 0.0.0.0，从 WAN 到达时不需要地址转换
    interfaces.pppoe-wan = {
      allowedTCPPorts = [ 11010 ];
      allowedUDPPorts = [ 11010 ];
    };
  };

  # 接受 tun0 进来的流量
  networking.firewall.extraInputRules = ''
    iifname "tun0" counter accept comment "easytier: input from tun0"
  '';
}

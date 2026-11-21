{ ... }:

let
  wanIface = "pppoe-wan";
  lanIface = "br-lan";
in
{
  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = 1;
    # 让后创建的接口也接受 RA
    "net.ipv6.conf.default.accept_ra" = 2;
  };

  systemd.network.networks = {
    "50-pppoe-wan" = {
      matchConfig.Name = wanIface;

      networkConfig = {
        # 只做 DHCPv6（PD），IPv4 由 pppd 管
        DHCP = "ipv6";
        IPv6AcceptRA = true;
        KeepConfiguration = "yes";
      };

      dhcpV6Config = {
        # 不等 M 标志，主动发 SOLICIT
        WithoutRA = "solicit";
        # WAN 地址走 SLAAC，不额外要 IA_NA
        UseAddress = false;
        UseDNS = false;
        UseNTP = false;
      };

      ipv6AcceptRAConfig = {
        # RA 不带 M 标志也拉起 DHCPv6 客户端
        DHCPv6Client = "always";
        UseDNS = false;
      };
    };

    "40-br-lan" = {
      networkConfig = {
        # 从委派前缀切 /64 配到桥上并发 RA
        DHCPPrefixDelegation = true;
        IPv6SendRA = true;
        # 不收回内网设备的 RA
        IPv6AcceptRA = false;
      };

      dhcpPrefixDelegationConfig = {
        UplinkInterface = wanIface;
      };

      ipv6SendRAConfig = {
        # 不跑 DHCPv6 服务端
        Managed = false;
        OtherInformation = false;
        RouterLifetimeSec = 1800;
        # 不发空 RDNSS
        EmitDNS = false;
        EmitDomains = false;
      };
    };
  };

}

{ config, ... }:
{
  services.pppd = {
    enable = true;
    peers.wan = {
      autostart = true;
      config = ''
        # 加载 PPPoE 插件
        plugin pppoe.so
        nic-eth0
        # 协商 IPv6CP 以拿到 link-local
        +ipv6
        ifname pppoe-wan
        lcp-echo-interval 1
        lcp-echo-failure 5
        lcp-echo-adaptive
        noauth
        defaultroute
        file ${config.sops.templates."pppoe-options".path}
      '';
    };
  };

  sops.secrets.pppoe_credentials = { };

  sops.templates."pppoe-options".content = ''
    ${config.sops.placeholder.pppoe_credentials}
  '';
}

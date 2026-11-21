{
  config,
  lib,
  ...
}:
{
  services.dnsmasq = {
    enable = true;

    settings = {
      # 只走 server 指定的那一个上游
      no-resolv = true;
      server = [ "127.0.0.1#7874" ];

      # 静态租约从 sops 渲染的文件读，别的 include 一律不引
      conf-file = lib.mkForce [ config.sops.secrets.dhcp_static_hosts.path ];

      # 不缓存，上游挂掉时立即失败
      cache-size = 0;

      # 域名及其所有子域都答这个地址
      address = [ "/feccc.site/192.168.200.200" ];

      dhcp-range = [ "192.168.0.100,192.168.255.249,255.255.0.0,12h" ];

      # 租约名带上 .local 后缀，内网主机名照旧按 xxx.local 解析
      domain = "local";
      # .local 由本机应答，绝不转发给上游
      local = [ "/local/" ];
    };
  };

  # 值形如 dhcp-host=<MAC>,<名字>,<IP>,<租期>，一行一条；dnsmasq 直接读这个文件
  sops.secrets.dhcp_static_hosts = {
    restartUnits = [ "dnsmasq.service" ];
  };

  # 本机解析不绕回 dnsmasq
  services.dnsmasq.resolveLocalQueries = false;

  networking.firewall.interfaces.br-lan = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}

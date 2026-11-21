{
  config,
  lib,
  pkgs,
  ...
}:
{
  # 22 只在 br-lan 放行
  services.openssh.openFirewall = false;

  # 先问本机 dnsmasq（内网 .local 名和 feccc.site 从它答），它答不了再用公共 DNS
  networking.nameservers = [
    "127.0.0.1"
    "223.5.5.5"
    "119.29.29.29"
  ];

  my_config.fail2ban.enable = true;

  # 沿用 my_config.netdata，只把包、采样与保留量压轻
  my_config.netdata = {
    enable = true;
    parentHost = "docker.local";
  };

  services.netdata = {
    package = lib.mkForce pkgs.netdata;

    # 共享模块那套是 1s / 3 层 / 1.4GiB 缓存；路由器只做子节点，压到 5s / 1 层 / 128MiB
    config.db = lib.mkForce {
      "enable replication" = "yes";
      "replication period" = "1d";
      "db" = "dbengine";
      "dbengine tier backfill" = "new";
      "update every" = "5s";
      "storage tiers" = "1";
      "dbengine page cache size" = "32MiB";
      "dbengine tier 0 retention size" = "128MiB";
    };
  };

  # 19999 不从 WAN 进
  networking.firewall.extraInputRules = ''
    iifname ${config.networking.nat.externalInterface} th dport 19999 counter reject
  '';
}

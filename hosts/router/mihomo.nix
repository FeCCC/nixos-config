{ config, lib, pkgs, ... }:
let
  shared = import ../../modules/nixos/mihomo/config.nix;

  mihomoConfig = shared // {
    dns = shared.dns // {
      listen = "0.0.0.0:7874";
    };

    tun = shared.tun // {
      enable = true;
      device = "utun";
      # 交给 mihomo 建立 ip rule、路由表和 utun 地址
      auto-route = true;
      auto-detect-interface = true;
      dns-hijack = [
        "any:53"
        "tcp://any:53"
      ];
    };
  };
in
{
  services.mihomo = {
    enable = true;
    tunMode = true;
    configFile = (pkgs.formats.yaml { }).generate "mihomo-config.yaml" mihomoConfig;
  };

  # 让 fatal 退出的进程被拉起（geo 或订阅拉不到时 mihomo 直接退出）
  systemd.services.mihomo.serviceConfig = {
    Restart = "always";
    # 取 5s：瞬时故障快速重试，又不到默认 5 次/10s 启动限速的密度
    RestartSec = 5;
  };

  # 放行从 utun 进来的回包
  networking.firewall.extraReversePathFilterRules = ''
    iifname "utun" counter accept
  '';

  networking.firewall.interfaces.br-lan = {
    allowedTCPPorts = [
      7874
      7890
      7891
      7892
      9090
    ];
    allowedUDPPorts = [
      7874
      7890
      7891
      7892
    ];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  mihomo-config = import ./config.nix;
in
{
  options.my_config.mihomo.enable = lib.mkEnableOption "enable mihomo TUN proxy";

  options.my_config.mihomo.tunStack = lib.mkOption {
    type = lib.types.enum [
      "gvisor"
      "system"
    ];
    default = "system";
  };

  # 是否开放 mihomo 的监听端口
  options.my_config.mihomo.openFirewall = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "是否开放 mihomo 的监听端口";
  };

  config = lib.mkIf config.my_config.mihomo.enable {
    services.mihomo = {
      enable = true;
      package = pkgs.unstable.mihomo;
      tunMode = true;
      webui = pkgs.zashboard;
      configFile = config.sops.templates."mihomo-config".path;
    };

    networking.firewall.allowedTCPPorts = lib.optionals config.my_config.mihomo.openFirewall [
      7890 # mixed
      7891 # socks5
      7892 # http
      9090 # 面板
    ];
    networking.firewall.allowedUDPPorts = lib.optionals config.my_config.mihomo.openFirewall [
      7890
      7891
      7892
    ];

    sops.templates.mihomo-config.content = builtins.readFile (
      (pkgs.formats.yaml { }).generate "mihomo-config.yaml" (
        mihomo-config
        // {
          tun = mihomo-config.tun // {
            stack = config.my_config.mihomo.tunStack;
          };
        }
      )
    );
  };
}

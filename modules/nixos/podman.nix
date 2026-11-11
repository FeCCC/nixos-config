{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my_config.podman = {
    enable = lib.mkEnableOption "use podman (rootless, alongside docker)";
  };

  config = lib.mkIf config.my_config.podman.enable {
    virtualisation.podman = {
      enable = true;
      # 默认网络默认关闭 DNS；compose 里按服务名互访需要打开
      # 默认网络是纯 v4；开 v6 要连 subnets 一起给全，浅合并会整体替换该列表
      defaultNetwork.settings = {
        dns_enabled = true;
        ipv6_enabled = true;
        subnets = [
          {
            subnet = "10.88.0.0/16";
            gateway = "10.88.0.1";
          }
          {
            subnet = "fd00:88::/64";
            gateway = "fd00:88::1";
          }
        ];
      };
    };

    environment.systemPackages = [ pkgs.podman-compose ];

    # 用户级 systemd 需在无人登录时运行，rootless 容器才能随开机启动
    users.users = lib.genAttrs config.my_config.normalUsers (user: {
      linger = true;
    });

    # 启用 podman 包自带的开机钩子：启动所有带 restart 策略的容器
    systemd.user.services.podman-restart.wantedBy = [ "default.target" ];
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my_config.docker = {
    enable = lib.mkEnableOption "use docker";
  };
  config = lib.mkIf config.my_config.docker.enable {
    users.users.miku.extraGroups = [ "docker" ];
    virtualisation.docker = {
      enable = true;
      liveRestore = false;
    };
    networking.firewall.extraInputRules = ''
      # v6 容器端口可达：Docker v4 靠 DNAT→FORWARD 自动放行，v6 无 DNAT 需在 INPUT 放行 ULA 内网
      ip6 saddr fd00::/8 accept
    '';
  };
}

# Windows VM（dockur/windows
{
  config,
  lib,
  ...
}:
{
  options.my_config.windows-vm.enable = lib.mkEnableOption "dockur/windows VM (quark client host)";

  config = lib.mkIf config.my_config.windows-vm.enable {
    # 磁盘镜像目录（ZFS rpool/appdata，394G 中 222G 空闲）
    system.activationScripts."windows-vm-data-dir" = {
      text = ''
        DATA_DIR=/data/appdata/windows-vm
        if [ ! -d "$DATA_DIR/storage" ]; then
          mkdir -p "$DATA_DIR/storage" "$DATA_DIR/shared"
        fi
      '';
    };

    virtualisation.oci-containers = {
      backend = "docker";
      containers.windows-vm = {
        image = "dockurr/windows";
        autoStart = true;

        environment = {
          VERSION = "10l"; # Win10 LTSC，镜像 4.7G 最轻
          LANGUAGE = "Chinese";
          DISK_SIZE = "64G"; # 虚拟盘上限，可后期调大不丢数据
          ALLOCATE = "N"; # 稀疏分配：实际占用按写入增长（装完约 15-20G）
          RAM_SIZE = "8G"; # 运行时上限，ballooning 动态归还
          CPU_CORES = "4";
          USERNAME = "docker";
          PASSWORD = "admin";
        };

        ports = [
          "8006:8006" # Web 查看/操作界面
          "3389:3389/tcp" # RDP
          "3389:3389/udp"
        ];

        volumes = [
          "/data/appdata/windows-vm/storage:/storage" # 系统盘 data.img
          "/data/appdata/windows-vm/shared:/shared" # 宿主机共享目录（Windows 里 \\host.lan\Data）
        ];

        extraOptions = [
          "--device=/dev/kvm"
          "--device=/dev/net/tun"
          "--cap-add=NET_ADMIN"
          "--stop-timeout=120" # 给 Windows 优雅关机时间
        ];
      };
    };

    # 容器端口经 DNAT 自动放行 v4；RDP/8006 需从局域网访问，显式放行
    networking.firewall.allowedTCPPorts = [
      8006
      3389
    ];
    networking.firewall.allowedUDPPorts = [ 3389 ];
  };
}

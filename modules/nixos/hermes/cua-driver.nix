{
  config,
  lib,
  pkgs,
  ...
}:
let
  # ── Computer Use (cua-driver) 虚拟桌面 ─────────────────────────────────
  # 启动顺序（wrapper 每次被 Hermes spawn 时执行）：
  #   Xvfb（displayNum）→ dbus session（全局共享）→ Openbox → AT-SPI bus → exec 真 cua-driver
  # 所有状态文件放容器 /tmp（tmpfs：容器重建即清空；放持久卷会跨重建残留、权限混战）。

  # 容器内 home。上游模块 containerHomeDir 固定为 "/home/hermes"（nixosModules.nix
  # 内部常量、非 option）；宿主机 users.users.hermes.home 是 /var/lib/hermes ——
  # 那是宿主侧路径，包装器运行在容器内，必须用容器路径。
  containerHome = "/home/hermes";

  # 虚拟桌面显示号：wrapper 与 env 模板共用，保持两处一致。
  displayNum = ":99";

  # cua-driver 虚拟桌面包装：先拉起桌面（Xvfb/dbus/Openbox/AT-SPI），再透传给真 cua-driver。
  # HERMES_CUA_DRIVER_CMD 官方机制：Hermes 只运行这个二进制、不重写它；容器重建后 store 路径仍有效。
  # Xvfb 必须 -nolisten tcp（容器 --network=host，只留 unix socket 防局域网暴露）+ -ac（容器内无鉴权设置）。
  cuaDriverXvfb = pkgs.writeShellScriptBin "cua-driver-xvfb" ''
    set -eu

    export DISPLAY="${displayNum}"

    # ── 通用存活检查：pidfile 的 pid 必须是「对应程序」，不是任意活进程（PID 复用误判）──
    alive() {
      [ -r "$1" ] || return 1
      local pid
      pid=$(cat "$1" 2>/dev/null) || return 1
      kill -0 "$pid" 2>/dev/null && grep -q "$2" "/proc/$pid/cmdline" 2>/dev/null
    }

    # ── Xvfb 虚拟桌面（判据：X socket 存在 + pid 归 Xvfb；容器缺 pgrep 用 pidfile）──
    # 注意：Xvfb 21.1.24 没有 -logfile 选项（那是 Xorg 的）——命令行带它会直接启动失败！
    XVFB_PIDFILE=/tmp/xvfb.pid
    XFB_SOCKET="/tmp/.X11-unix/X${lib.removePrefix ":" displayNum}"
    if [ ! -S "$XFB_SOCKET" ] || ! alive "$XVFB_PIDFILE" Xvfb; then
      nohup ${pkgs.xvfb}/bin/Xvfb "${displayNum}" -screen 0 1280x800x24 -nolisten tcp -ac >/dev/null 2>&1 &
      echo $! > "$XVFB_PIDFILE"
      sleep 1
    fi

    # ── dbus session bus ───────────────────────────────────────────────
    # 坑 1：NixOS store 的 dbus-daemon 没有 /etc/dbus-1/session.conf（该文件由 NixOS
    #       systemd dbus 模块生成，Ubuntu 容器里不存在）→ 必须 --config-file 指包内
    #       session.conf；且 --session 与 --config-file 互斥，只能二选一。
    # 坑 2：--print-address 只接受 1/2（stdout/stderr），不接受文件名 → 用前台模式 +
    #       nohup 后台：stdout 重定向到 addrfile（地址行），pidfile 即真实 daemon pid。
    # 坑 3：bus 必须全局共享（/tmp 固定文件）。Hermes 每次 spawn 都是新 wrapper 进程，
    #       若不共享，每个 driver 实例连不同 bus，AT-SPI launcher 只注册在它第一次
    #       连的 bus 上 → driver 永远看不到 org.a11y.Bus → "no windows"。
    # 坑 4：跨用户安全（root 跑 doctor / hermes 跑 gateway 混用）：/tmp 是 sticky，
    #       非 owner 不能 rm → 不 rm，用 truncate 覆盖 + chmod 666；日志走 /dev/null
    #       （日志文件的所有权问题会让整条 nohup 命令失败）。
    export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/tmp/xdg-runtime}"
    mkdir -p "$XDG_RUNTIME_DIR" 2>/dev/null || true
    chmod 700 "$XDG_RUNTIME_DIR" 2>/dev/null || true
    if [ -z "''${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
      DBUS_PIDFILE=/tmp/dbus-session.pid
      DBUS_ADDRFILE=/tmp/dbus-session-address
      if ! alive "$DBUS_PIDFILE" dbus-daemon; then
        : > "$DBUS_ADDRFILE"; chmod 666 "$DBUS_ADDRFILE" 2>/dev/null || true
        nohup ${pkgs.dbus}/bin/dbus-daemon --config-file=${pkgs.dbus}/share/dbus-1/session.conf --print-address=1 > "$DBUS_ADDRFILE" 2>/dev/null &
        echo $! > "$DBUS_PIDFILE"; chmod 666 "$DBUS_PIDFILE" 2>/dev/null || true
        for _ in 1 2 3 4 5 6 7 8 9 10; do [ -s "$DBUS_ADDRFILE" ] && break; sleep 0.2; done
      fi
      export DBUS_SESSION_BUS_ADDRESS="$(cat "$DBUS_ADDRFILE" 2>/dev/null | head -1 || true)"
    fi

    # ── Openbox 窗口管理器（判据同上：pid 必须归 Openbox）──
    OPENBOX_PIDFILE=/tmp/openbox.pid
    if ! alive "$OPENBOX_PIDFILE" openbox; then
      nohup ${pkgs.openbox}/bin/openbox >/dev/null 2>&1 &
      echo $! > "$OPENBOX_PIDFILE"
    fi

    # ── AT-SPI 无障碍总线（org.a11y.Bus；UI 元素树依赖）───────────────────
    # dbus 的 service-activation 只扫 $XDG_DATA_DIRS/dbus-1/services，Nix store 不在
    # 默认搜索路径 → 显式注入 at-spi2-core 的 share，并直接拉起 launcher。
    # 判据必须是「当前共享 bus 上 org.a11y.Bus 是否有 owner」，不是「launcher 进程
    # 是否活着」：launcher 可能连在旧 bus 上（进程活着注册在别处），只看 pidfile
    # 会导致新 bus 永远没人注册。
    export XDG_DATA_DIRS="${pkgs.at-spi2-core}/share:''${XDG_DATA_DIRS:-}"
    if ! ${pkgs.dbus}/bin/dbus-send --session --dest=org.freedesktop.DBus --type=method_call \
         --print-reply /org/freedesktop/DBus org.freedesktop.DBus.NameHasOwner \
         string:org.a11y.Bus 2>/dev/null | grep -q "boolean true"; then
      nohup ${pkgs.at-spi2-core}/libexec/at-spi-bus-launcher >/dev/null 2>&1 &
      echo $! > /tmp/at-spi-bus-launcher.pid; chmod 666 /tmp/at-spi-bus-launcher.pid 2>/dev/null || true
      sleep 2
    fi

    # ── 透传给真 cua-driver（Hermes 以 `serve --embedded --socket ...` 调用）──
    if [ ! -x "${containerHome}/.local/bin/cua-driver" ]; then
      echo "cua-driver not installed. Run inside the hermes container: hermes computer-use install" >&2
      exit 1
    fi
    exec "${containerHome}/.local/bin/cua-driver" "$@"
  '';
in
{
  config = lib.mkIf config.my_config.hermes-agent.enable {

    # ── cua-driver 虚拟桌面的环境变量（sops 模板 → .env → Hermes 进程环境）──
    # DISPLAY + HERMES_CUA_DRIVER_CMD（官方 driver 定位点）。environmentFiles 按顺序
    # 追加到 hermes-env（mkEnvScript：先写 environment= base 再 cat 各文件，
    # python-dotenv 后值覆盖先值），与她 agents 的模板合并无冲突。
    # 注意：模板值是容器内路径（store 挂载是容器内可见的绝对路径）。
    sops.templates."cua-driver-env" = {
      content = lib.generators.toKeyValue { } {
        DISPLAY = displayNum;
        HERMES_CUA_DRIVER_CMD = "${cuaDriverXvfb}/bin/cua-driver-xvfb";
      };
      mode = "0400";
    };

    # ── 虚拟桌面组件进系统闭包 ────────────────────────────────────────────
    # Xvfb wrapper 引用的二进制须显式进 extraPackages（GC root + 构建），容器内
    # wrapper 用绝对 store 路径调用（容器 ro 挂载 /nix/store），不依赖 PATH。
    services.hermes-agent = {
      environmentFiles = [
        config.sops.templates."cua-driver-env".path
      ];
      extraPackages = [
        pkgs.xvfb
        pkgs.openbox
        pkgs.dbus
        pkgs.at-spi2-core
        cuaDriverXvfb
      ];
    };
  };
}

{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    # DMS NixOS 模块（系统级安装）
    inputs.dms.nixosModules.dank-material-shell
    # DMS greeter 模块
    inputs.dms.nixosModules.greeter
  ];

  config = lib.mkIf config.my_config.desktop.enable {

    programs.niri.enable = true;
    programs.xwayland.enable = true;

    # ── DankMaterialShell ──
    programs.dank-material-shell = {
      enable = true;
      systemd.enable = true;

      # dgop 不在 nixpkgs stable 里，用 unstable 版
      dgop.package = pkgs.unstable.dgop;

      # 功能开关
      enableSystemMonitoring = true;   # dgop 系统监控
      enableVPN = true;                # VPN 管理控件
      enableDynamicTheming = true;     # matugen 动态配色
      enableAudioWavelength = true;    # cava 音频可视化
      enableCalendarEvents = false;    # khal 日历（不用可以关）
      enableClipboardPaste = true;     # 剪贴板粘贴
    };

    # ── DMS Greeter（替代 cosmic-greeter）──
    programs.dank-material-shell.greeter = {
      enable = true;
      compositor.name = "niri";
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
    };

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];

  };
}

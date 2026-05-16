{ pkgs, ... }:
{
  programs.xwayland.enable = true;

  # ── DankMaterialShell ──
  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    # dgop 不在 nixpkgs stable 里，用 unstable 版
    dgop.package = pkgs.unstable.dgop;

    # 功能开关
    enableSystemMonitoring = true; # dgop 系统监控
    enableVPN = true; # VPN 管理控件
    enableDynamicTheming = true; # matugen 动态配色
    enableAudioWavelength = true; # cava 音频可视化
    enableCalendarEvents = true; # khal 日历
    enableClipboardPaste = true; # 剪贴板粘贴
  };

  # ── DMS Greeter ──
  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "niri";
  };

  # services.xserver.enable = true;
  # services.flatpak.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-rime
      ];
      waylandFrontend = true;
    };
  };
}

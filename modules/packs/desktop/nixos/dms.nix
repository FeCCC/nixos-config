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

    # 功能开关
    enableSystemMonitoring = true; # system monitoring
    enableVPN = true; # VPN 管理控件
    enableDynamicTheming = true; # matugen 动态配色
    enableAudioWavelength = true; # cava 音频可视化
    enableCalendarEvents = true; # khal 日历
    enableClipboardPaste = true; # 剪贴板粘贴
  };

  # ── DMS Greeter ──
  programs.dms-greeter = {
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

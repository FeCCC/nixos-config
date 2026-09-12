{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  # DMS 生成的 niri 片段（~/.config/niri/dms/*.kdl）；内容归 DMS 写，这里只挑哪些被 include
  niriIncludes = [
    "alttab"
    "binds"
    "colors"
    "input"
    "layout"
    "outputs"
    "wpblur"
    "cursor"
    "windowrules"
  ];
in
{
  programs.dank-material-shell = {
    enable = true;

    settings = {
      currentThemeName = "custom";
      currentThemeCategory = "registry";
      customThemeFile = inputs.catppuccin-dms + "/catppuccin.json";
      registryThemeVariants.catppuccin.dark = {
        flavor = "macchiato";
        accent = "sky";
      };
      runUserMatugenTemplates = true;
      runDmsMatugenTemplates = true;
      clockDateFormat = "yyyy/MM/dd dddd";
      showSeconds = true;
      padHours12Hour = true;
      monoFontFamily = "DejaVu Sans Mono";
      showDock = false;
      use24HourClock = false;
      weatherEnabled = true;
      useAutoLocation = true;
      runningAppsCompactMode = true;
      showWorkspaceIndex = true;
      launcherLogoMode = "os";
    };

    session = {
      isLightMode = false;
      weatherLocation = "武汉";
    };

    niri.includes = {
      enable = true;
      override = true;
      originalFileName = "hm";
      filesToInclude = niriIncludes;
    };
  };

  # 片段不存在时先建空文件，避免 include 缺失警告；已存在的不要动（内容归 DMS）
  home.activation.dmsNiriIncludes = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ~/.config/niri/dms
    for f in ${lib.concatStringsSep " " niriIncludes}; do
      if [ ! -f ~/.config/niri/dms/$f.kdl ]; then
        touch ~/.config/niri/dms/$f.kdl
      fi
    done
  '';
}

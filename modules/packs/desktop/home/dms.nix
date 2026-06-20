{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.dank-material-shell = {
    enable = true;

    dgop.package = pkgs.unstable.dgop;

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
      filesToInclude = [
        "alttab"
        "binds"
        "colors"
        "layout"
        "outputs"
        "wpblur"
        "cursor"
        "windowrules"
      ];
    };
  };

  # 新环境没有 dms/*.kdl 时生成空文件，避免 niri 因 include 缺失而 panic
  home.activation.dmsNiriIncludes = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ~/.config/niri/dms
    for f in alttab binds colors layout outputs wpblur cursor windowrules; do
      if [ ! -f ~/.config/niri/dms/$f.kdl ]; then
        touch ~/.config/niri/dms/$f.kdl
      fi
    done
  '';
}

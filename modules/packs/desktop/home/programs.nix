{ ... }:
{
  programs.mpv.enable = true;

  programs.thunderbird = {
    enable = true;
    profiles."default".isDefault = true;
  };

  programs.firefox = {
    enable = true;
    languagePacks = [ "zh-CN" ];
    profiles."default" = {
      isDefault = true;
      settings = {
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        "intl.locale.requested" = "zh-CN,en-US";
      };
    };
  };

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        front_end = "WebGpu",
        mouse_bindings = {
          {
            event = { Down = { streak = 1, button = "Right" } },
            mods = "NONE",
            action = wezterm.action.PasteFrom("Clipboard"),
          },
        },
      }
    '';
    enableZshIntegration = false;
    enableBashIntegration = false;
  };
}

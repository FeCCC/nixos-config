{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.niri
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
    ./dms.nix
    ./niri.nix
  ];
  options.my_config.desktop.enable = lib.mkEnableOption "use desktop";

  config = lib.mkIf config.my_config.desktop.enable {

    programs.mpv = {
      enable = true;
    };
    programs.thunderbird = {
      enable = true;
      profiles = {
        "default" = {
          isDefault = true;
        };
      };
    };
    programs.firefox = {
      enable = true;
      languagePacks = [ "zh-CN" ];
      profiles = {
        "default" = {
          isDefault = true;
          settings = {
            "sidebar.revamp" = true;
            "sidebar.verticalTabs" = true;
            "intl.locale.requested" = "zh-CN,en-US";
          };
        };
      };
    };
    programs.wezterm = {
      enable = true;
      extraConfig = ''return { front_end = "WebGpu" }'';
      enableZshIntegration = false;
      enableBashIntegration = false;
    };
  };
}

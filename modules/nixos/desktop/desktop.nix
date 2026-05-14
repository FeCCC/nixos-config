{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my_config.desktop.enable {
    services.xserver.enable = true;

    services.flatpak.enable = true;

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
  };
}

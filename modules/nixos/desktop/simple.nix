{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.my_os_config.desktop.enable {
    environment.systemPackages = with pkgs; [
      google-chrome
      # citrix_workspace
      keepassxc
      unstable.zed-editor
      qq
      vscode
      libreoffice
      telegram-desktop
      steam
      osu-lazer
      yesplaymusic
      rustdesk
      siyuan
    ];
  };
}
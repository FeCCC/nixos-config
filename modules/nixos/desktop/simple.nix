{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my_os_config.desktop.enable {
    environment.systemPackages = with pkgs; [
      # citrix_workspace
      keepassxc
      unstable.zed-editor
      qq
      vscode
      libreoffice
      telegram-desktop
      osu-lazer-bin
      yesplaymusic
      rustdesk
      siyuan
      veracrypt
      gnucash
      uget
      sigil
    ];

    programs.steam.enable = true;
  };
}

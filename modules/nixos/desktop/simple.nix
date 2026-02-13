{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my_config.desktop.enable {
    environment.systemPackages = with pkgs; [
      keepassxc
      unstable.zed-editor
      qq
      vscode
      libreoffice
      telegram-desktop
      osu-lazer-bin
      rustdesk
      siyuan
      veracrypt
      gnucash
      sigil
      discord
      unstable.simplex-chat-desktop
      lutris
      signal-desktop
      hmcl
    ];

    programs.steam.enable = true;
  };
}

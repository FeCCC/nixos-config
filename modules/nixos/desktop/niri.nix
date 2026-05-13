{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = lib.mkIf config.my_config.desktop.enable {

    programs.niri.enable = true;
    programs.waybar.enable = true;
    programs.xwayland.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
    };

    environment.systemPackages = with pkgs; [
      fuzzel
      alacritty
      swaybg
      xwayland-satellite
    ];

  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my_os_config.desktop.enable {
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;
    # services.displayManager.cosmic-greeter.enable = true;
    # services.desktopManager.cosmic.enable = true;

    services.xrdp = {
      enable = true;
      defaultWindowManager = "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-x11";
      # defaultWindowManager = "${pkgs.cosmic-session}/bin/start-cosmic";
      audio.enable = true;
      openFirewall = true;
    };

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

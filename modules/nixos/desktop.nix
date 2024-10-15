{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my_config.desktop.enable = lib.mkEnableOption "use desktop";

  config = lib.mkIf config.my_config.desktop.enable {
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;
    environment.systemPackages = with pkgs; [
      google-chrome
      # citrix_workspace
    ];
  };
}

{
  os_config,
  lib,
  ...
}: {
  # options.my_os_config.desktop.enable = lib.mkEnableOption "use desktop";

  config = lib.mkIf os_config.my_os_config.desktop.enable {
    programs.mpv = {enable = true;};
  };
}

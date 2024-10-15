{
  config,
  pkgs,
  lib,
  ...
}: {
  options.my_config.docker = {
    enable = lib.mkEnableOption "use docker";
  };
  config = lib.mkIf config.my_config.docker.enable {
    virtualisation.docker = {
      enable = true;
      liveRestore = false;
    };
  };
}

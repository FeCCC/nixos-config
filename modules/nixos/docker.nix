{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my_config.docker = {
    enable = lib.mkEnableOption "use docker";
  };
  config = lib.mkIf config.my_config.docker.enable {
    users.users.miku.extraGroups = [ "docker" ];
    virtualisation.docker = {
      enable = true;
      liveRestore = false;
    };
  };
}

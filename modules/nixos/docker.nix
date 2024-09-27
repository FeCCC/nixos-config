{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    usedocker = lib.mkEnableOption "use docker";
  };
  config = lib.mkIf config.usedocker {
    virtualisation.docker.enable = true;
  };
}

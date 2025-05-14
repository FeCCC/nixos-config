{
  config,
  lib,
  ...
}:
{
  services.syncthing = {
    enable = true;
    user = "miku";
    dataDir = "/home/miku";
    guiAddress = lib.mkIf (lib.hasAttr "wsl" config && config.wsl.enable) "127.0.0.1:8385";
  };

}

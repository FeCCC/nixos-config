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
  };

}

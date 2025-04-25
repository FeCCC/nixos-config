{ ... }:
{
  services.syncthing = {
    enable = true;
    user = "miku";
    dataDir = "/home/miku/syncthing";
  };
}

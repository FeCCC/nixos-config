{
  lib,
  ...
}:
{
  imports = [ ./common.nix ];

  networking.hostName = "wsl-thinkbook-x";

  my_config.mihomo.enable = true;
  my_config.i2pd.enable = true;
  my_config.tor.enable = true;
}

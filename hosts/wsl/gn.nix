{
  lib,
  ...
}:
{
  imports = [ ./common.nix ];

  networking.hostName = "wsl-gn";

  my_config.desktop.enable = lib.mkForce false;
  my_config.mihomo.enable = false;
}

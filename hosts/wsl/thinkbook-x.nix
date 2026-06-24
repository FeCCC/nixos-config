{
  lib,
  ...
}:
{
  imports = [ ./common.nix ];

  networking.hostName = "wsl-thinkbook-x";

  my_config.mihomo.enable = true;

  nixpkgs.config.cudaSupport = lib.mkForce false;
  home-manager.users = {
    root.nixpkgs.config.cudaSupport = lib.mkForce false;
    miku.nixpkgs.config.cudaSupport = lib.mkForce false;
  };
}

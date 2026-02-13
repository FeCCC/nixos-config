{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  networking.hostName = "nixos";

  boot.loader.grub.device = "nodev";

  boot.kernelPatches = [
    {
      name = "bbr";
      patch = null;
      extraStructuredConfig = with pkgs.lib.kernel; {
        TCP_CONG_BBR = yes; # enable BBR
        DEFAULT_BBR = yes; # use it by default
      };
    }
  ];

  my_config.docker.enable = true;
  my_config.desktop.enable = true;
}

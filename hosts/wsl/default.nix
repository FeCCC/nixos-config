{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    ./hardware-configuration.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "miku";
  };

  networking.hostName = "nixos-wsl";
  my_os_config.desktop.enable = true;

  # BEGIN: Docker Desktop WSL Integration
  wsl.extraBin = with pkgs; [
    { src = "${uutils-coreutils-noprefix}/bin/cat"; }
    { src = "${uutils-coreutils-noprefix}/bin/whoami"; }
    { src = "${busybox}/bin/addgroup"; }
    { src = "${su}/bin/groupadd"; }
  ];
  # END: Docker Desktop WSL Integration
}

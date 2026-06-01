{
  inputs,
  pkgs,
  lib,
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
    wslConf.network.generateHosts = false;
  };

  networking.extraHosts = ''
    fe00::0 ip6-localnet
    ff00::0 ip6-mcastprefix
    ff02::1 ip6-allnodes
    ff02::2 ip6-allrouters
  '';

  networking.wireless.enable = lib.mkForce false;
  networking.hostName = "nixos-wsl";
  my_config.desktop.enable = true;
  my_config.netdata.enable = false;
  my_config.mihomo.enable = true;

  environment.extraInit = ''
    export NIX_LD_LIBRARY_PATH="$NIX_LD_LIBRARY_PATH:/usr/lib/wsl/lib/"
  '';

  environment.sessionVariables = {
    ZED_ALLOW_EMULATED_GPU = 1;
  };

  services.openssh.ports = [ 8822 ];
  services.syncthing.guiAddress = "127.0.0.1:8385";
  # BEGIN: Docker Desktop WSL Integration
  wsl.extraBin = with pkgs; [
    { src = "${uutils-coreutils-noprefix}/bin/cat"; }
    { src = "${uutils-coreutils-noprefix}/bin/whoami"; }
    { src = "${busybox}/bin/addgroup"; }
    { src = "${su}/bin/groupadd"; }
  ];
  # END: Docker Desktop WSL Integration
}

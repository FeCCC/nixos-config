{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    google-chrome
    baidupcs-go
  ];

  networking.hostName = "nixos-ThinkPad-E470";
  networking.firewall.allowedTCPPorts = [ 18789 ];

  my_os_config.docker.enable = true;
  my_os_config.desktop.enable = true;

}

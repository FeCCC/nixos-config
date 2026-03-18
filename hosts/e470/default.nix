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

  home-manager.users.miku = {
    home.packages = with pkgs; [
      nodejs
      pnpm
      yarn
      gnumake
      cmake
      gcc
      libgcc
    ];
    programs.zsh.initContent = ''
      export PATH=$PATH:$(npm config get prefix)/bin
      export PATH=$PATH:$(yarn global bin)
      export PATH=$PATH:$(pnpm bin -g)
    '';
    programs.bash.bashrcExtra = ''
      export PATH=$PATH:$(npm config get prefix)/bin
      export PATH=$PATH:$(yarn global bin)
      export PATH=$PATH:$(pnpm bin -g)
    '';
  };

  environment.systemPackages = with pkgs; [
    google-chrome
    baidupcs-go
    python3
  ];

  networking.hostName = "nixos-ThinkPad-E470";
  networking.firewall.allowedTCPPorts = [ 18789 ];

  my_config.docker.enable = true;
  my_config.desktop.enable = true;
  my_config.netdata.enable = true;
}

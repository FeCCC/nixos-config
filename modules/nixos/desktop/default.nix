{ lib, config, ... }:
{
  # List your module files here
  # my-module = import ./my-module.nix;
  imports = [
    ./desktop.nix
    ./simple.nix
    ./fonts.nix
  ];

  options.my_config.desktop.enable = lib.mkEnableOption "use desktop";

  config = lib.mkIf config.my_config.desktop.enable {
    home-manager.sharedModules = [
      {
        my_config.desktop.enable = true;
      }
    ];
  };
}

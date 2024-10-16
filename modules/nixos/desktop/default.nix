# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{lib, ...}: {
  # List your module files here
  # my-module = import ./my-module.nix;
  imports = [
    ./desktop.nix
    ./simple.nix
    ./fonts.nix
  ];

  options.my_config.desktop.enable = lib.mkEnableOption "use desktop";
}

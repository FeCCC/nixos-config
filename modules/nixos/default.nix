# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  imports = [
    ./simple.nix
    ./yggdrasil.nix
    ./docker.nix
    ./syncthing.nix
    ./desktop
    ./i2pd.nix
  ];

  environment.shellAliases = {
    ll = "ls -l";
    la = "ls -a";
  };
}

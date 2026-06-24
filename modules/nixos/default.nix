let
  scanPacks = import ../common/packs.nix;
in
{
  imports = [
    ../common/nixpkgs.nix
    ./simple.nix
    ./yggdrasil.nix
    ./docker.nix
    ./syncthing.nix
    ./i2pd.nix
    ./tor.nix
    ./netdata.nix
    ./hermes
    ./easytier.nix
    ./mihomo
  ]
  ++ scanPacks ../packs "nixos";

  environment.shellAliases = {
    ll = "ls -l";
    la = "ls -a";
  };
}

let
  scanPacks = import ../common/packs.nix;
in
{
  imports = [
    ../common/nixpkgs.nix
    ./simple.nix
    ./fabric.nix
    ./yggdrasil.nix
    ./docker.nix
    ./podman.nix
    ./syncthing.nix
    ./i2pd.nix
    ./tor.nix
    ./netdata.nix
    ./fail2ban.nix
    ./hermes
    ./easytier.nix
    ./mihomo
    ./windows-vm.nix
  ]
  ++ scanPacks ../packs "nixos";

  environment.shellAliases = {
    ll = "ls -l";
    la = "ls -a";
  };
}

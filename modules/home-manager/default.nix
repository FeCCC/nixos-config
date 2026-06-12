let
  scanPacks = import ../common/packs.nix;
in
{
  imports = [
    ./common.nix
    ./sops.nix
    ./helix.nix
    ./zsh.nix
    ./ssh.nix
    ./neovim
    ./yazi.nix
    ./simple.nix
    ./opencode
    ./nh.nix
  ]
  ++ scanPacks ../packs "home";
}

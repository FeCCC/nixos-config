{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    ripgrep
    tree
    sops
    age
    ssh-to-pgp
    ssh-to-age
    htop
    iftop
    neofetch
    zellij
    iperf3
    wget
    file
    which
  ];
}

{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    busybox
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
    unzip
    fzf
    alejandra
  ];
}

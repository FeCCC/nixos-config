{
  inputs,
  pkgs,
  ...
}: {
  programs.nix-ld.enable = true;
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
    fastfetch
    zellij
    iperf3
    wget
    file
    which
    unzip
    fzf
    alejandra
    aria2
    mosh
    ncdu
    acme-sh
  ];
}

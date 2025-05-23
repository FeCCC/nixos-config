let
  common_programs = [
    "lazygit"
    "bat"
  ];
  nixos_programs = [
    "iftop"
    "nix-ld"
    "mosh"
  ] ++ common_programs;
  home_programs = [
    "home-manager"
    "ripgrep"
    "htop"
    "btop"
    "fastfetch"
    "zellij"
    "fzf"
    "aria2"
    "zoxide" # for zsh
    "fd"
    "bottom"
  ] ++ common_programs;
  pkgs = [
    "busybox"
    "tree"
    "sops"
    "age"
    "ssh-to-pgp"
    "ssh-to-age"
    "neofetch"
    "iperf"
    "wget"
    "file"
    "which"
    "unzip"
    "nixfmt-rfc-style"
    "ncdu"
    "acme-sh"
    "ffmpeg-headless"
    "lrzsz"
    "rsync"
    "devenv"
    "dysk"
    "inxi"
    "dust"
  ];
in
{
  inherit pkgs;
  nixos = nixos_programs;
  home = home_programs;
}

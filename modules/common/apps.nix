let
  common_programs = [
    "lazygit"
  ];
  nixos_programs = [
    "nix-ld"
  ]
  ++ common_programs;
  home_programs = [
    "home-manager"
    "ripgrep"
    "htop"
    "btop"
    "fastfetch"
    "zellij"
    "fzf"
    "zoxide" # for zsh
    "fd"
  ]
  ++ common_programs;
  pkgs = [
    "tree"
    "sops"
    "age"
    "ssh-to-pgp"
    "ssh-to-age"
    "wget"
    "file"
    "which"
    "unzip"
    "nixfmt"
    "ncdu"
    "ffmpeg-headless"
    "lrzsz"
    "rsync"
    "devenv"
    "dysk"
    "dust"
    "python3"
  ];
in
{
  inherit pkgs;
  nixos = nixos_programs;
  home = home_programs;
}

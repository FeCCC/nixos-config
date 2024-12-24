let
  common_programs = [
    "lazygit"
  ];
  nixos_programs =
    [
      "iftop"
      "nix-ld"
      "mosh"
    ]
    ++ common_programs;
  home_programs =
    [
      "home-manager"
      "ripgrep"
      "htop"
      "fastfetch"
      "zellij"
      "fzf"
      "aria2"
    ]
    ++ common_programs;
  pkgs =
    [
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
      "alejandra"
      "ncdu"
      "acme-sh"
      "ffmpeg-headless"
    ]
    ++ nixos_programs
    ++ home_programs;
in {
  inherit pkgs;
  nixos = nixos_programs;
  home = home_programs;
}

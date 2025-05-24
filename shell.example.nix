let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-25.05";
  pkgs = import nixpkgs {
    config = { };
    overlays = [ ];
  };
in
pkgs.mkShellNoCC {
  hardeningDisable = [ "all" ];
  packages = with pkgs; [
    gnumake
    automake
    autoconf
    autogen
    gcc
    gdb
    lldb
    python3
    uv
    conda
    jupyter
    perl
    util-linux
    pkg-config
    openssl
    binutils
    ncurses
    zlib
    elfutils
    bear
  ];

  LD_LIBRARY_PATH =
    with pkgs;
    lib.makeLibraryPath [
      ncurses
      elfutils
      libgcc
    ];

  shellHook = ''
    # for wsl
    # export LD_LIBRARY_PATH="/usr/lib/wsl/lib:$LD_LIBRARY_PATH"
  '';
}

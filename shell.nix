{pkgs, ...}: {
  default = pkgs.mkShell {
    packages = with pkgs; [
      gnumake
      gcc
      gdb
      lldb
      python3
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
    ];

    shellHook = ''
      export LD_LIBRARY_PATH="${pkgs.ncurses.out}/lib:${pkgs.elfutils.out}/lib:$LD_LIBRARY_PATH"
      exec zsh
    '';
  };
  node = pkgs.mkShell {
    packages = with pkgs; [
      nodejs
    ];

    shellHook = ''
      exec zsh
    '';
  };
}

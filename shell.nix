{pkgs, ...}: {
  default = pkgs.mkShell {
    packages = with pkgs; [
      gnumake
      gcc
      python3
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
}

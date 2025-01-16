{
  pkgs,
  pkgs-2305,
  ...
}: {
  default = pkgs.mkShellNoCC {
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

    shellHook = ''
      export LD_LIBRARY_PATH="${pkgs.libgcc.lib}/lib:${pkgs.ncurses.out}/lib:${pkgs.elfutils.out}/lib:$LD_LIBRARY_PATH"
      exec zsh
    '';
  };

  node = pkgs.mkShellNoCC {
    packages = with pkgs; [
      nodejs
    ];

    shellHook = ''
      exec zsh
    '';
  };

  rust = pkgs.mkShellNoCC {
    packages = with pkgs; [
      cargo
      rustc
      rustfmt
      rust-analyzer
      lldb
      pkg-config
    ];

    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    LD_LIBRARY_PATH = with pkgs;
      lib.makeLibraryPath [
        libGL
        libxkbcommon
        wayland
        xorg.libX11
      ];

    shellHook = ''
      exec zsh
    '';
  };

  gcc48 = pkgs.mkShellNoCC {
    packages = with pkgs;
      [
        gnumake
        automake
        autoconf
        autogen
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
        bear
      ]
      ++ [pkgs-2305.gcc48];

    shellHook = ''
      export LD_LIBRARY_PATH="${pkgs.ncurses.out}/lib:${pkgs.elfutils.out}/lib:$LD_LIBRARY_PATH"
      exec zsh
    '';
  };
}

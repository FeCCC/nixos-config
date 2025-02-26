{
  pkgs,
  pkgs-2305,
  ...
}: {
  default = pkgs.mkShellNoCC {
    hardeningDisable = ["all"];
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
      zlib
      bear
    ];

    LD_LIBRARY_PATH = with pkgs;
      lib.makeLibraryPath [
        ncurses
        elfutils
        libgcc
      ];

    shellHook = ''
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
    hardeningDisable = ["all"];
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
        zlib
        bear
      ]
      ++ [pkgs-2305.gcc48];

    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.ncurses
      pkgs.elfutils
      pkgs-2305.gcc48.cc.lib
    ];

    shellHook = ''
    '';
  };
}

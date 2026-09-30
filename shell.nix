{
  pkgs,
  pkgs-2405,
  ...
}:
{
  default = pkgs.mkShellNoCC {
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
      # openssl_1_1
      binutils
      zlib
      bear
      elfutils
      ncurses
      zstd
      krb5
      e2fsprogs
    ];

    LD_LIBRARY_PATH =
      with pkgs;
      lib.makeLibraryPath [
        ncurses
        elfutils
        libgcc
        krb5
        e2fsprogs
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
    LD_LIBRARY_PATH =
      with pkgs;
      lib.makeLibraryPath [
        libGL
        libxkbcommon
        wayland
        libx11
      ];

    shellHook = ''
      exec zsh
    '';
  };

  gcc48 = pkgs-2405.mkShellNoCC {
    hardeningDisable = [ "all" ];

    packages = with pkgs-2405; [
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
      openssl_1_1
      binutils
      zlib
      bear
      gcc48
      elfutils
      ncurses
      zstd
      krb5
      e2fsprogs
    ];

    LD_LIBRARY_PATH =
      with pkgs-2405;
      lib.makeLibraryPath [
        ncurses
        elfutils
        krb5
        e2fsprogs
        # pkgs-2405.gcc48.cc.lib
      ];

    shellHook = ''
      exec zsh
    '';
  };
}

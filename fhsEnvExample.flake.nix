{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = { };
        overlays = [ ];
      };
    in
    {
      devShells.x86_64-linux.default =
        (pkgs.buildFHSEnv {
          name = "build-env";
          targetPkgs =
            pkgs: with pkgs; [
              gnumake
              automake
              autoconf
              autogen
              gcc
              libgcc
              libgccjit
              clang
              glibc.dev
              python311
              python311Packages.distutils
              perl
              util-linux
              pkg-config
              openssl
              binutils
              ncurses
              ncurses.dev
              zlib
              bzip2
              bzip2.dev
              elfutils
              linuxHeaders
            ];
          runScript = pkgs.writeShellScript "init.sh" ''
            # wsl
            # export PATH=$(echo "$PATH" | sed 's/:/\n/g' | awk '!/\/mnt\/c\/Users/ && !/\/mnt\/c\/Program/ && !/\/mnt\/c\/WINDOWS/ || /x410/' | xargs | tr ' ' ':')
            exec zsh
          '';
        }).env;
    };
}

{
  description = "nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    nixpkgs-2305.url = "github:nixos/nixpkgs/nixos-23.05";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # wsl
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sops-nix
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos-anywhere
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #nixvim
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      # If using a unstable channel you can use `url = "github:nix-community/nixvim`
      # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>`
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-2305,
      nixpkgs-unstable,
      home-manager,
      nixos-wsl,
      sops-nix,
      disko,
      nixvim,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      # Supported systems for your flake packages, shell, etc.
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsForSystem =
        system:
        import nixpkgs {
          inherit system;
          config.permittedInsecurePackages = [
            "openssl-1.1.1w"
          ];
        };

      mkNixOSConfiguration =
        {
          modules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            # > Our main nixos configuration file <
            ./nixos/configuration.nix
          ] ++ modules;
        };

      mkHomeConfiguration =
        {
          system,
          modules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system}; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs;
            os_config = {
              my_os_config.desktop.enable = false;
            };
          };
          modules = [
            sops-nix.homeManagerModules.sops
          ] ++ modules;
        };
    in
    {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'nixfmt-rfc-style' include 'alejandra'
      formatter = forAllSystems (system: nixpkgs-unstable.legacyPackages.${system}.nixfmt-tree);

      devShells = forAllSystems (
        system:
        import ./shell.nix {
          pkgs = pkgsForSystem system;
          pkgs-2305 = import nixpkgs-2305 {
            inherit system;
            config.permittedInsecurePackages = [
              "openssl-1.1.1w"
            ];
          };
        }
      );

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        nixos = mkNixOSConfiguration { modules = [ ./hosts/common.nix ]; };
        nixos-wsl = mkNixOSConfiguration { modules = [ ./hosts/wsl.nix ]; };
        nixos-server = mkNixOSConfiguration { modules = [ ./hosts/server.nix ]; };
      };

      homeConfigurations = {
        miku = mkHomeConfiguration {
          system = "x86_64-linux";
          modules = [ ./home-manager/miku.nix ];
        };
        wl = mkHomeConfiguration {
          system = "x86_64-linux";
          modules = [ ./home-manager/wl.nix ];
        };
        root = mkHomeConfiguration {
          system = "x86_64-linux";
          modules = [ ./home-manager/root.nix ];
        };
      };
    };
}

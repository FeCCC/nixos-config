{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager
  ];

  environment.systemPackages = [inputs.home-manager.packages.${pkgs.system}.default];

  home-manager = {
    sharedModules = [inputs.sops-nix.homeManagerModules.sops];
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      # Import your home-manager configuration
      root = import ../home-manager/root.nix;
      miku = import ../home-manager/miku.nix;
    };
  };
}

{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager
  ];

  # home-manager tools
  # environment.systemPackages = [inputs.home-manager.packages.${pkgs.system}.default];

  home-manager = {
    sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
    extraSpecialArgs = {
      inherit inputs outputs;
      os_config = config;
    };
    users = {
      # Import your home-manager configuration
      root = import ../home-manager/root.nix;
      miku = import ../home-manager/miku.nix;
    };
  };
}

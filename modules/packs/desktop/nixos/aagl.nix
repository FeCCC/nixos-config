{
  inputs,
  ...
}:
{
  nix.settings = inputs.aagl.nixConfig; # Set up Cachix
  programs.honkers-railway-launcher.enable = true;
  aagl.enableNixpkgsReleaseBranchCheck = false;
}

{ ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
  };
}

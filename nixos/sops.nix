{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.keyFile = "/var/lib/sops-keys";

  sops.secrets.miku_password.neededForUsers = true;
}

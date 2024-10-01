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
  sops.secrets.sops_keys = {
    path = "/var/lib/sops-keys";
    owner = "root";
  };
}

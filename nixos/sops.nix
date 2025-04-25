{
  inputs,
  outputs,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.keyFile = "/var/lib/sops-keys";

  sops.secrets.miku_password.neededForUsers = true;

  sops.secrets.sops_keys_init = {
    path = "/root/.config/sops/sops_keys_init.sh";
    mode = "0755";
  };

  sops.secrets.user_sops_keys_init = {
    path = "/root/.config/sops/user_sops_keys_init.sh";
    mode = "0755";
  };
}

{
  inputs,
  outputs,
  config,
  ...
}: {
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";

  sops.secrets.sops_keys_init = {
    path = "${config.xdg.configHome}/sops/sops_keys_init.sh";
    mode = "0755";
  };

  sops.secrets.user_sops_keys_init = {
    path = "${config.xdg.configHome}/sops/user_sops_keys_init.sh";
    mode = "0755";
  };
}

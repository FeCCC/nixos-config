{
  inputs,
  outputs,
  config,
  ...
}: {
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.age.keyFile = "${config.xdg.configHome}/sops/age/keys";

  # sops.secrets.user_sops_keys = {
  #   path = "${config.xdg.configHome}/sops/age/keys";
  #   mode = "0600";
  # };
}

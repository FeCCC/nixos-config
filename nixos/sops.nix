{
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.keyFile = "/root/.config/sops/age/keys.txt";
  # Make sure that `/var/lib/sops` is owned by root and is not world-readable/writable
  # sops.gnupg.home = "/var/lib/sops";
  # disable importing host ssh keys
  # sops.gnupg.sshKeyPaths = [];
  sops.secrets.miku_password.neededForUsers = true;
}

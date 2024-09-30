{
  config,
  pkgs,
  ...
}: {
  # {
  users.users = {
    miku = {
      isNormalUser = true;

      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel" "docker"];
      # initialHashedPassword = "$y$j9T$0qp58xTtzVJ6Z6N7zSDgZ1$zd36bLicL2LFYCiNRuacDMpJTPPQ.l.CR8JpgB.rBnA";
      hashedPasswordFile = config.sops.secrets.miku_password.path;
      shell = pkgs.zsh;
    };
  };
}

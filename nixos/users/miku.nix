{
  config,
  pkgs,
  ...
}:
{
  # {
  users.users = {
    miku = {
      isNormalUser = true;
      uid = 1000;

      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDTnTcp/8Jxd3HOcOzYHaUFQq/7AWlmeomGrhmhkCJqSXaWQoBbec3nsETozjdQ/UMdhKSA+A0eO/zzWdiEQjZ+d31LA52/+CsgYhvNKXutkcwf/2zTFlc8gZyGqv7oWWguBgS8+0itQ9CcShnjCGeH0q4awkYTGRMmJ4xCgkLglgZuvLk6p3cUgerkekuBswGNjCDm1BAqzG5xcY96BvZGkmX+o2g4Hv0q7RhA3HKod7JFYsQFsa6KS5afYC+1XxI5G/dctvrOcenbu3dCGaStKMONpsri/Al1cp1DquUkOJZxb5Q4MoEC2o54R5b/XVqE/koE9DY0S/aAGQWFjXt+Cb+9c0gF5L8KWzfQCC6Z/7jcgv/oLIZJfuHrefIJS2jY7ZOE4OqMk+N7qmGYCd2Z9KnjyX6DaKJSvR9dKRWoMyfgQ8mlvvS2dAmwlcjouedo1ys03tLCACGBbQCAuk6z5Jh5q3LwO8Y7MC9+Vd1jWTPKRVRpss5uNpzyAufd6Z3os4CL1nM88TxsG/9SDc1GCvocq7tWQaEa/EczzkWfMECZu19G0d0I093qqOZtyCHXA86Jv+rOMJhZoUVsRJvsBTiLqXqSPmMqG+Fw1dR4LJj3FwlILb6c+nXnZhJRHnRl0LohQJOleNBXXsvebh4iNCy9xuHBAzRUA9D8Xxjf+w== MIKU"
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [
        "wheel"
        "docker"
        "i2pd"
      ];
      # initialHashedPassword = "$y$j9T$0qp58xTtzVJ6Z6N7zSDgZ1$zd36bLicL2LFYCiNRuacDMpJTPPQ.l.CR8JpgB.rBnA";
      hashedPasswordFile = config.sops.secrets.miku_password.path;
      shell = pkgs.zsh;
    };
  };
}

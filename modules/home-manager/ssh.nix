{
  config,
  lib,
  ...
}: {
  options.my_hm_config.ssh.enable = lib.mkEnableOption "my ssh";

  config = lib.mkIf config.my_hm_config.ssh.enable {
    programs.ssh = {
      enable = true;
      extraConfig = ''
        # Host github.com
        #     HostName github.com
        #     User git
        #     PreferredAuthentications publickey
        #     IdentityFile ~/.ssh/id_github


        # Host ssh.github.com
        # 无法使用ssh连接时，使用通过https的ssh连接
        Host github.com
            HostName ssh.github.com
            User git
            Port 443
            PreferredAuthentications publickey
            IdentityFile ~/.ssh/id_github

        Host git.feccc.site
            HostName git.feccc.site
            User git
            Port 222
            PreferredAuthentications publickey
            IdentityFile ~/.ssh/id_git_feccc
      '';
    };

    sops.secrets.id_rsa_pub = {
      path = "${config.home.homeDirectory}/.ssh/id_rsa.pub";
    };
    sops.secrets.id_rsa = {
      path = "${config.home.homeDirectory}/.ssh/id_rsa";
    };
    sops.secrets.id_github_pub = {
      path = "${config.home.homeDirectory}/.ssh/id_github.pub";
    };
    sops.secrets.id_github = {
      path = "${config.home.homeDirectory}/.ssh/id_github";
    };
    sops.secrets.id_git_feccc_pub = {
      path = "${config.home.homeDirectory}/.ssh/id_git_feccc.pub";
    };
    sops.secrets.id_git_feccc = {
      path = "${config.home.homeDirectory}/.ssh/id_git_feccc";
    };
    sops.secrets.id_hexo_pub = {
      path = "${config.home.homeDirectory}/.ssh/id_hexo.pub";
    };
    sops.secrets.id_hexo = {
      path = "${config.home.homeDirectory}/.ssh/id_hexo";
    };
  };
}

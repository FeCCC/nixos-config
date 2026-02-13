{
  config,
  lib,
  ...
}:
{
  options.my_config.ssh.enable = lib.mkEnableOption "my ssh";

  config = lib.mkIf config.my_config.ssh.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        # "github.com" = {
        #   hostname = "github.com";
        #   user = "git";
        #   identityFile = "~/.ssh/id_github";
        # };
        # 无法使用ssh连接时，使用通过https的ssh连接
        "github.com" = {
          hostname = "ssh.github.com";
          user = "git";
          port = 443;
          identityFile = "~/.ssh/id_github";
        };
        "git.feccc.site" = {
          hostname = "git.feccc.site";
          user = "git";
          port = 222;
          identityFile = "~/.ssh/id_git_feccc";
        };
        "*" = {
          forwardAgent = false;
          addKeysToAgent = "yes";
          compression = false;
          serverAliveInterval = 60;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "auto";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
          identityFile = "~/.ssh/id_rsa_default";
        };
      };
    };

    sops.secrets.id_rsa_default_pub = {
      path = "${config.home.homeDirectory}/.ssh/id_rsa_default.pub";
    };
    sops.secrets.id_rsa_default = {
      path = "${config.home.homeDirectory}/.ssh/id_rsa_default";
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

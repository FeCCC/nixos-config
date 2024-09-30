{config, ...}: {
  sops.secrets.id_github_pub = {
    path = "/root/.ssh/id_github.pub";
  };
  sops.secrets.id_github = {
    path = "/root/.ssh/id_github";
  };
  sops.secrets.id_git_feccc_pub = {
    path = "/root/.ssh/id_git_feccc.pub";
  };
  sops.secrets.id_git_feccc = {
    path = "/root/.ssh/id_git_feccc";
  };
  sops.secrets.id_hexo_pub = {
    path = "/root/.ssh/id_hexo.pub";
  };
  sops.secrets.id_hexo = {
    path = "/root/.ssh/id_hexo";
  };
}

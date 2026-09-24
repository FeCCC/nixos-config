{
  config,
  lib,
  ...
}:
let
  domain = "feccc.site";
in
{
  security.acme = {
    acceptTerms = true;
    certs.${domain} = {
      extraDomainNames = [ "*.${domain}" ];
      dnsProvider = "tencentcloud";
      dnsPropagationCheck = true;
      # 传播检查直查 DNSPod 权威，避免内网/递归缓存造成假已传播
      dnsResolver = "111.13.13.35";
      environmentFile = config.sops.templates."acme-env".path;
      postRun = ''
        CERT_DOMAIN=${domain} /var/lib/cert-deploy.sh
      '';
    };
  };

  sops.secrets = {
    tencentcloud_secret_id = { };
    tencentcloud_secret_key = { };
    deploy_env = { };
  };

  sops.templates."acme-env" = {
    owner = "acme";
    content =
      lib.generators.toKeyValue { } {
        TENCENTCLOUD_SECRET_ID = config.sops.placeholder.tencentcloud_secret_id;
        TENCENTCLOUD_SECRET_KEY = config.sops.placeholder.tencentcloud_secret_key;
        TENCENTCLOUD_PROPAGATION_TIMEOUT = "600";
        TENCENTCLOUD_POLLING_INTERVAL = "10";
      }
      + config.sops.placeholder.deploy_env;
  };
}

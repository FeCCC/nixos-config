{
  config,
  lib,
  pkgs,
  ...
}:
let
  stateDir = config.services.hermes-agent.stateDir;
in
{
  config = lib.mkIf config.my_config.hermes-agent.enable {

    # Signal 账号手机号
    sops.secrets.signal-account = { };

    sops.templates."signal-cli-env" = {
      content = lib.generators.toKeyValue { } {
        SIGNAL_CLI_ACCOUNT = config.sops.placeholder.signal-account;
      };
    };

    # signal-cli 数据目录 — 持久化账号密钥
    system.activationScripts."signal-cli-data-dir" = {
      text = ''
        DATA_DIR=${stateDir}/signal-cli
        if [ ! -d "$DATA_DIR" ]; then
          mkdir -p "$DATA_DIR"
          chown 999:999 "$DATA_DIR"
          chmod 750 "$DATA_DIR"
        fi
      '';
      deps = [ "hermes-agent-setup" ];
    };

    virtualisation.oci-containers = {
      backend = "docker";
      containers.signal-cli = {
        image = "ghcr.io/asamk/signal-cli:latest";
        autoStart = true;
        ports = [ "8116:8080" ];
        environmentFiles = [
          config.sops.templates."signal-cli-env".path
        ];
        volumes = [
          # 数据目录：signal-cli 自身配置/数据
          "${stateDir}/signal-cli:/var/lib/signal-cli"
          # 与 hermes-agent 容器的 /data/signal-cli 共享同一宿主目录，
          # 让网关真实路径 /data/signal-cli 在容器内也可读（发图附件用）
          "${stateDir}/signal-cli:/data/signal-cli"
        ];
        cmd = [
          "daemon"
          "--http"
          "0.0.0.0:8080"
        ];
      };
    };

  };
}

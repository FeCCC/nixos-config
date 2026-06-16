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

    # 将 new-api 的 key 写入 Hindsight 需要的 env 格式
    sops.templates."hindsight-env" = {
      content = lib.generators.toKeyValue { } {
        HINDSIGHT_API_LLM_BASE_URL = config.sops.placeholder.new_api_base_url_for_openai;
        HINDSIGHT_API_LLM_API_KEY = config.sops.placeholder.new_api_key;
      };
      mode = "0400";
    };

    # Hindsight 数据目录 — 确保容器挂载目录存在且权限正确
    system.activationScripts."hindsight-data-dir" = {
      text = ''
        DATA_DIR=${stateDir}/hindsight/data
        if [ ! -d "$DATA_DIR" ]; then
          mkdir -p "$DATA_DIR"
          chown 1000:1000 "$DATA_DIR"
          chmod 750 "$DATA_DIR"
        fi
      '';
      deps = [ "hermes-agent-setup" ];
    };

    virtualisation.oci-containers = {
      backend = "docker";
      containers.hindsight = {
        image = "ghcr.io/vectorize-io/hindsight:latest";
        autoStart = true;

        ports = [
          "8114:8888"
          "9999:9999"
        ];

        environment = {
          HINDSIGHT_API_LLM_PROVIDER = "openai";
          HINDSIGHT_API_LLM_MODEL = "deepseek-v4-flash";
        };

        environmentFiles = [
          config.sops.templates."hindsight-env".path
        ];

        volumes = [
          "${stateDir}/hindsight/data:/home/hindsight/.pg0"
        ];
      };
    };
  };
}

{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  stateDir = config.services.hermes-agent.stateDir;
  hp = config.services.hermes-agent.package.python.pkgs;
  hindsightSrc = "${inputs.hindsight}/hindsight-integrations/hermes";
  hindsightVersion =
    dir:
    (builtins.fromTOML (builtins.readFile "${inputs.hindsight}/${dir}/pyproject.toml")).project.version;

  # 依赖在运行期由 sealed venv 提供，构建环境里没有：
  # propagatedBuildInputs 留空（声明同名包会撞碰撞检查），并关掉运行期依赖检查
  hindsightClient = hp.buildPythonPackage {
    pname = "hindsight-client";
    version = hindsightVersion "hindsight-clients/python";
    src = "${inputs.hindsight}/hindsight-clients/python";
    format = "pyproject";
    build-system = [ hp.hatchling ];
    dontCheckRuntimeDeps = true;
  };
  hindsightEmbed = hp.buildPythonPackage {
    pname = "hindsight-embed";
    version = hindsightVersion "hindsight-embed";
    src = "${inputs.hindsight}/hindsight-embed";
    format = "pyproject";
    build-system = [ hp.hatchling ];
    dontCheckRuntimeDeps = true;
  };
  aiohttpRetry = hp.buildPythonPackage {
    pname = "aiohttp-retry";
    version = "2.9.1";
    src = "${inputs.aiohttp-retry}";
    format = "pyproject";
    build-system = [ hp.setuptools ];
    dontCheckRuntimeDeps = true;
    # setup.py 的版本串停在 2.9.0，标签已是 v2.9.1
    postPatch = ''
      substituteInPlace setup.py --replace-fail 'version="2.9.0"' 'version="2.9.1"'
    '';
  };
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
          HINDSIGHT_API_LLM_MODEL = "deepseek-flash";
        };

        environmentFiles = [
          config.sops.templates."hindsight-env".path
        ];

        volumes = [
          "${stateDir}/hindsight/data:/home/hindsight/.pg0"
        ];
      };
    };

    # hindsight 插件的 Python 依赖
    services.hermes-agent.extraPythonPackages = [
      hindsightClient
      hindsightEmbed
      aiohttpRetry
    ];

    # 插件目录：目录名必须是 hindsight —— 记忆 provider 按 <HERMES_HOME>/plugins/<name> 精确匹配
    system.activationScripts."hermes-hindsight-plugin" = {
      text = ''
        DIR=${stateDir}/.hermes/plugins
        mkdir -p "$DIR"
        if [ -d "$DIR/hindsight" ] && [ ! -L "$DIR/hindsight" ]; then
          echo "hermes-agent: WARNING $DIR/hindsight is a real directory; leaving it alone" >&2
        else
          ln -sfn ${hindsightSrc} "$DIR/hindsight"
        fi
        chown -h ${config.services.hermes-agent.user}:${config.services.hermes-agent.group} "$DIR/hindsight" 2>/dev/null || true
      '';
      deps = [ "hermes-agent-setup" ];
    };
  };
}

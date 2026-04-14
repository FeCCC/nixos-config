{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.hermes-agent.nixosModules.default
  ];

  options.my_config.hermes-agent = {
    enable = lib.mkEnableOption "hermes-agent";
  };

  config = lib.mkIf config.my_config.hermes-agent.enable {

    sops.secrets.new_api_key = { };
    sops.secrets.new_api_base_url_for_openai = { };

    # 使用 sops template 生成配置文件，通过 configFile 注入
    # 避免在 settings 中写入 base_url，防止明文存储
    sops.templates."hermes-agent-config" = {
      content = ''
        model:
          provider: custom:new-api
          default: "gemini-3.1-pro-preview"
          context_length: 1048576

        fallback_model:
          provider: custom:new-api
          model: Pro/deepseek-ai/DeepSeek-V3.2
          context_length: 163840

        custom_providers:
          - name: "new-api"
            base_url: ${config.sops.placeholder.new_api_base_url_for_openai}
            api_key: ${config.sops.placeholder.new_api_key}
            models:
              gemini-3.1-pro-preview:
                context_length: 1048576
              Pro/deepseek-ai/DeepSeek-V3.2:
                context_length: 163840
      '';
    };

    # Hermes Agent 服务配置
    services.hermes-agent = {
      enable = true;

      # 使用容器模式
      container.enable = true;

      # 通过 configFile 指定 sops 模板生成的配置文件
      # 这样 base_url 不会以明文形式出现在 /nix/store
      configFile = config.sops.templates."hermes-agent-config".path;

      # 将 hermes CLI 添加到系统 PATH，并全局设置 HERMES_HOME
      addToSystemPackages = true;
    };

    users.users.miku.extraGroups = [ "hermes" ];
  };
}

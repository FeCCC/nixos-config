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

    sops.secrets.telegram_bot_token = { };
    sops.secrets.telegram_user_id = { };
    sops.secrets.qq_bot_app_id = { };
    sops.secrets.qq_bot_client_secret = { };
    sops.secrets.qq_bot_allowed_user = { };

    sops.templates."hermes-env" = {
      content = ''
        TELEGRAM_BOT_TOKEN=${config.sops.placeholder.telegram_bot_token}
        TELEGRAM_ALLOWED_USERS=${config.sops.placeholder.telegram_user_id}
        QQ_APP_ID=${config.sops.placeholder.qq_bot_app_id}
        QQ_CLIENT_SECRET=${config.sops.placeholder.qq_bot_client_secret}
        QQ_ALLOWED_USERS=${config.sops.placeholder.qq_bot_allowed_user}
      '';
    };

    sops.secrets.new_api_key = { };
    sops.secrets.new_api_base_url_for_openai = { };

    # 使用 sops template 生成配置文件，通过 configFile 注入
    # 避免在 settings 中写入 base_url，防止明文存储
    sops.templates."hermes-agent-config" = {
      content = ''
        model:
          base_url: ${config.sops.placeholder.new_api_base_url_for_openai}
          api_key: ${config.sops.placeholder.new_api_key}
          provider: custom
          default: "gemini-3.1-pro-preview"
          context_length: 1048576

        fallback_model:
          base_url: ${config.sops.placeholder.new_api_base_url_for_openai}
          api_key: ${config.sops.placeholder.new_api_key}
          provider: custom
          model: Pro/deepseek-ai/DeepSeek-V3.2
          context_length: 163840

        custom_providers:
          - name: "new-api"
            base_url: ${config.sops.placeholder.new_api_base_url_for_openai}
            api_key: ${config.sops.placeholder.new_api_key}
            models:
              gemini-3.1-pro-preview:
                context_length: 1048576
      '';
    };

    # Hermes Agent 服务配置
    services.hermes-agent = {
      enable = true;

      # 使用容器模式
      container.enable = true;

      environmentFiles = [ config.sops.templates."hermes-env".path ];

      # 通过 configFile 指定 sops 模板生成的配置文件
      # 这样 base_url 不会以明文形式出现在 /nix/store
      configFile = config.sops.templates."hermes-agent-config".path;

      # 将 hermes CLI 添加到系统 PATH，并全局设置 HERMES_HOME
      addToSystemPackages = true;
    };

    sops.secrets.hermes-agent-password = { };
    # restic 备份
    services.restic.backups = {
      hermes-agent-bak = {
        initialize = true;
        passwordFile = config.sops.secrets.hermes-agent-password.path;
        paths = [
          config.services.hermes-agent.stateDir
        ];
        exclude = [
          "current-entrypoint"
          "current-package"
          ".env"
          ".gc-root"
          ".gc-root-entrypoint"
        ];
        repository = "sftp:miku@truenas.local:/mnt/NAS/share/Documents/Backup/hermes-agent/${config.networking.hostName}";
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
          RandomizedDelaySec = "5h";
        };
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
          "--keep-yearly 5"
        ];
      };
    };

    users.users.miku.extraGroups = [ "hermes" ];
  };
}

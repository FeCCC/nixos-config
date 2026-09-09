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
    ./cua-driver.nix
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
    sops.secrets.qq_bot_home_channel = { };
    sops.secrets.hermes-email-address = { };
    sops.secrets.hermes-email-password = { };
    sops.secrets.hermes-email-home-address = { };
    sops.secrets.feishu_appid = { };
    sops.secrets.feishu_app_secret = { };
    sops.secrets.feishu_allowed_users = { };
    sops.secrets.feishu_home_channel = { };
    sops.secrets.fal_api_key = { };
    sops.secrets.hermes_api_server_key = { };
    sops.secrets.hermes_a2a_peer_tokens = { };
    sops.secrets.gn_agent_a2a_tokens = { };

    sops.templates."hermes-env" =
      let
        hermes-env = {
          OPENAI_API_KEY = config.sops.placeholder.new_api_key;

          # Telegram
          TELEGRAM_BOT_TOKEN = config.sops.placeholder.telegram_bot_token;
          TELEGRAM_ALLOWED_USERS = config.sops.placeholder.telegram_user_id;
          TELEGRAM_HOME_CHANNEL = config.sops.placeholder.telegram_user_id;

          # QQ
          QQ_APP_ID = config.sops.placeholder.qq_bot_app_id;
          QQ_CLIENT_SECRET = config.sops.placeholder.qq_bot_client_secret;
          QQ_ALLOWED_USERS = config.sops.placeholder.qq_bot_allowed_user;
          QQBOT_HOME_CHANNEL = config.sops.placeholder.qq_bot_home_channel;

          # Email
          EMAIL_ADDRESS = config.sops.placeholder.hermes-email-address;
          EMAIL_PASSWORD = config.sops.placeholder.hermes-email-password;
          EMAIL_IMAP_HOST = "imap.feccc.site";
          EMAIL_SMTP_HOST = "smtp.feccc.site";

          #FeiShu
          FEISHU_CONNECTION_MODE = "websocket";
          FEISHU_DOMAIN = "feishu";
          FEISHU_APP_ID = config.sops.placeholder.feishu_appid;
          FEISHU_APP_SECRET = config.sops.placeholder.feishu_app_secret;
          FEISHU_ALLOWED_USERS = config.sops.placeholder.feishu_allowed_users;
          FEISHU_HOME_CHANNEL = config.sops.placeholder.feishu_home_channel;

          # Security (recommended)
          EMAIL_ALLOWED_USERS = config.sops.placeholder.hermes-email-home-address;

          # Optional — Seconds between inbox checks (default: 15)
          EMAIL_IMAP_PORT = 993;
          EMAIL_SMTP_PORT = 587;
          EMAIL_POLL_INTERVAL = 15;
          EMAIL_HOME_ADDRESS = config.sops.placeholder.hermes-email-home-address;

          # Image gen
          FAL_KEY = config.sops.placeholder.fal_api_key;

          HERMES_MEDIA_ALLOW_DIRS = "/data:/home/hermes:/tmp";

          # API SERVER
          API_SERVER_ENABLED = "true";
          API_SERVER_HOST = "0.0.0.0";
          API_SERVER_PORT = "8642";
          API_SERVER_KEY = config.sops.placeholder.hermes_api_server_key;

          # A2A (Agent-to-Agent)
          # 安全机制：配了 token 才真正绑定 0.0.0.0，否则插件自动回落 127.0.0.1
          A2A_PORT = "9900";
          A2A_AGENT_NAME = config.networking.hostName;
          A2A_HOST = "0.0.0.0";
          A2A_PEER_TOKENS = config.sops.placeholder.hermes_a2a_peer_tokens;

          # Signal
          SIGNAL_HTTP_URL = "http://${config.networking.hostName}.local:8116";
          SIGNAL_ACCOUNT = config.sops.placeholder.signal-account;
          SIGNAL_ALLOWED_USERS = config.sops.placeholder.signal-account;
          SIGNAL_HOME_CHANNEL = config.sops.placeholder.signal-account;
        };
      in
      {
        content = lib.generators.toKeyValue { } hermes-env;
      };

    networking.firewall.allowedTCPPorts = [
      8642 # API SERVER
      9900 # A2A 开放端口
    ];

    sops.secrets.new_api_key = { };
    sops.secrets.new_api_base_url_for_openai = { };

    # 使用 sops template 生成配置文件，通过 configFile 注入
    # 避免在 settings 中写入 base_url，防止明文存储
    sops.templates."hermes-agent-config" =
      let
        hermes-config = {
          timezone = "Asia/Shanghai";
          display.busy_input_mode = "interrupt"; # 新传入的消息中断当前操作并立即被处理
          model = {
            provider = "new-api";
            default = "glm-5.3-flash";
          };
          fallback_model = {
            base_url = config.sops.placeholder.new_api_base_url_for_openai;
            provider = "custom";
            key_env = "OPENAI_API_KEY";
            model = "deepseek-v4-flash-vision-exp";
            context_length = 1048576;
            max_tokens = 384000;
            supports_vision = true;
          };
          auxiliary = {
            compression = {
              provider = "new-api";
              model = "deepseek-v4-flash";
            };
            vision = {
              provider = "new-api";
              model = "orcarouter/Qwen3.8-27B-Uncensored:q4_K_M";
            };
            approval = {
              provider = "new-api";
              model = "deepseek-v4-flash";
            };
          };
          providers = {
            "new-api" = {
              base_url = config.sops.placeholder.new_api_base_url_for_openai;
              key_env = "OPENAI_API_KEY";
              models = {
                "gemini-3.1-pro-preview" = {
                  context_length = 1048576;
                };
                "deepseek-v4-pro" = {
                  context_length = 1048576;
                  max_tokens = 384000;
                };
                "deepseek-v4-flash" = {
                  context_length = 1048576;
                  max_tokens = 384000;
                };
                "deepseek-v4-flash-vision-exp" = {
                  context_length = 1048576;
                  max_tokens = 384000;
                  supports_vision = true;
                };
                "kimi-k3" = {
                  context_length = 1048576;
                };
                "glm-5.3-flash" = {
                  context_length = 1000000;
                  max_tokens = 131071;
                  supports_vision = true;
                };
              };
            };
          };
          moa = {
            default_preset = "default";
            presets = {
              default = {
                reference_models = [
                  {
                    provider = "new-api";
                    model = "deepseek-v4-pro";
                  }
                  {
                    provider = "new-api";
                    model = "gemini-3.1-pro-preview";
                  }
                  {
                    provider = "new-api";
                    model = "kimi-k3";
                  }
                ];
                aggregator = {
                  provider = "new-api";
                  model = "deepseek-v4-pro";
                };
                max_tokens = 384000;
                fanout = "per_iteration";
                enabled = true;
              };
            };
          };
          image_gen.model = "fal-ai/gpt-image-2";
          memory = {
            provider = "hindsight";
            user_profile_enabled = true;
            memory_enabled = true;
          };
          agent = {
            reasoning_overrides = {
              "deepseek-v4-flash" = "max";
              "deepseek-v4-flash-vision-exp" = "max";
              "deepseek-v4-pro" = "max";
            };
          };
          approvals = {
            mode = "smart";
            destructive_slash_confirm = false; # /clear, /new, /reset, /undo 不再弹出确认
          };
          # A2A 出站工具：a2a 在默认关闭清单中，需按平台显式启用
          platform_toolsets = {
            cli = [
              "hermes-cli"
              "a2a"
            ];
            qqbot = [
              "hermes-qqbot"
              "a2a"
            ];
            telegram = [
              "hermes-telegram"
              "a2a"
            ];
            feishu = [
              "hermes-feishu"
              "a2a"
            ];
            email = [
              "hermes-email"
              "a2a"
            ];
            signal = [
              "hermes-signal"
              "a2a"
            ];
            webhook = [
              "hermes-webhook"
              "a2a"
            ];
            api_server = [
              "hermes-api-server"
              "a2a"
            ];
            cron = [
              "hermes-cron"
              "a2a"
            ];
          };
          # A2A 出站对端；有对端 agent 时按以下格式添加（token 走 sops placeholder）：
          # a2a_agents.researcher = {
          #   url = "http://192.168.x.x:9900";
          #   auth.type = "bearer";
          #   auth.token = "...";
          # };
          a2a_agents = {
            gn-agent = {
              url = "http://[201:397a:cb96:f2a5:df5f:2a23:6ab7:ad52]:9900";
              auth = {
                type = "bearer";
                token = config.sops.placeholder.gn_agent_a2a_tokens;
              };
            };
          };
          terminal.cwd = "/data/workspace";
          mcp_servers = {
            "codebase-memory-mcp" = {
              command = "${
                inputs.codebase-memory-mcp.packages.${pkgs.stdenv.hostPlatform.system}.default
              }/bin/codebase-memory-mcp";
              env = {
                CBM_CACHE_DIR = "/tmp/codebase-memory-mcp";
              };
            };
          };
        };
      in
      {
        content = builtins.readFile ((pkgs.formats.yaml { }).generate "hermes-config.yaml" hermes-config);
      };

    # A2A 入站 IPv6 代理：a2a 插件（ThreadingHTTPServer）只绑 IPv4，
    # 用 v6-only 监听转发，使 Yggdrasil 等 IPv6 对端可达（与容器内 0.0.0.0:9900 同端口共存，v4/v6 地址族不冲突）
    systemd.services.a2a-ipv6-proxy = {
      description = "A2A IPv6 to IPv4 forward";
      after = [
        "network.target"
        "hermes-agent.service"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.socat}/bin/socat TCP6-LISTEN:9900,ipv6only=1,fork,reuseaddr TCP4:127.0.0.1:9900";
        Restart = "always";
        RestartSec = "5";
      };
    };

    # Hermes Agent 服务配置
    services.hermes-agent = {
      enable = true;

      # 使用容器模式
      container = {
        enable = true;
        # /tmp 用 tmpfs
        extraOptions = [
          "--tmpfs"
          "/tmp:rw,size=1g"
        ];
      };

      environmentFiles = [ config.sops.templates."hermes-env".path ];

      # 通过 configFile 指定 sops 模板生成的配置文件
      # 这样 base_url 不会以明文形式出现在 /nix/store
      configFile = config.sops.templates."hermes-agent-config".path;

      # 将 hermes CLI 添加到系统 PATH，并全局设置 HERMES_HOME
      addToSystemPackages = true;

      # codebase-memory-mcp — 代码库知识图谱 MCP server
      extraPackages = [
        inputs.codebase-memory-mcp.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      extraDependencyGroups = [
        "fal" # 图片生成
        "messaging"
        "hindsight"
        "feishu"
      ];
    };

    # hermes 所需 Hindsight 连接配置（供 activationScripts 复制到hermes目录内实文件）
    sops.templates."hindsight-hermes-config" = {
      content = builtins.toJSON {
        mode = "local_external";
        api_url = "http://${config.networking.hostName}.local:8114";
        recall_budget = "mid";
        memory_mode = "hybrid";
        auto_retain = true;
        auto_recall = true;
      };
      mode = "0600";
    };

    # 将 Hindsight 连接配置复制到容器内可达路径
    system.activationScripts."hermes-hindsight-config" = {
      text = ''
        DIR=${config.services.hermes-agent.stateDir}/.hermes/hindsight
        mkdir -p "$DIR"
        cp -L ${config.sops.templates."hindsight-hermes-config".path} "$DIR/config.json"
        chown ${config.services.hermes-agent.user}:${config.services.hermes-agent.group} "$DIR/config.json"
        chmod 600 "$DIR/config.json"
      '';
      deps = [
        "setupSecrets"
        "hermes-agent-setup"
      ];
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
        extraBackupArgs = [
          "--pack-size 128" # 最大128MB
        ];
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
          "--max-unused 10%"
        ];
      };
    };

    users.users.miku.extraGroups = [ config.services.hermes-agent.group ];
  };
}

# omp shared configuration — single source of truth
# Imported by home-manager (omp/default.nix)

{ config }:

{
  # ── Application Settings (config.yml) ──
  appConfig = {
    providers = {
      webSearch = "public";
    };
    symbolPreset = "unicode";
    setupVersion = 1;
    theme = {
      dark = "titanium";
      light = "light";
    };
    modelRoles = {
      default = "new-api/deepseek-v4-pro";
      smol = "new-api/deepseek-v4-flash";
    };
    tools = {
      approvalMode = "write";
      approval = {
        bash = "allow"; # cat/ls/cargo 自动；rm -rf / 等危险操作强制弹窗
        task = "allow"; # 子代理自动
        browser = "allow"; # 浏览器测试自动
        debug = "allow"; # 调试自动
      };
    };
    edit = {
      mode = "hashline";
    };
    retry = {
      modelFallback = true;
    };
    debug = {
      enabled = true;
    };
  };

  # ── Model/Provider Definitions (models.json) ──
  modelsConfig = {
    providers = {
      new-api = {
        baseUrl = config.sops.placeholder.new_api_base_url_for_openai;
        apiKey = "OPENAI_API_KEY";
        api = "openai-completions";
        models = [
          {
            id = "deepseek-v4-pro";
            name = "DeepSeek V4 Pro";
            contextWindow = 1048576;
            maxTokens = 384000;
          }
          {
            id = "deepseek-v4-flash";
            name = "DeepSeek V4 Flash";
            contextWindow = 1048576;
            maxTokens = 384000;
          }
          {
            id = "deepseek/deepseek-v4-pro";
            name = "deepseek/deepseek-v4-pro";
            contextWindow = 1048576;
            maxTokens = 384000;
          }
          {
            id = "deepseek/deepseek-v4-flash";
            name = "deepseek/deepseek-v4-flash";
            contextWindow = 1048576;
            maxTokens = 384000;
          }
          {
            id = "deepseek/deepseek-v3.2";
            name = "DeepSeek V3.2";
            contextWindow = 163840;
            maxTokens = 163840;
          }
          {
            id = "deepseek-ai/DeepSeek-V4-Flash";
            name = "deepseek-ai/DeepSeek-V4-Flash";
            contextWindow = 1048576;
            maxTokens = 384000;
          }
          {
            id = "minimax/minimax-m2.1";
            name = "MiniMax M2.1";
            contextWindow = 204800;
            maxTokens = 204800;
          }
          {
            id = "x-ai/grok-4.1-fast";
            name = "Grok 4.1 Fast";
            contextWindow = 2000000;
            maxTokens = 2000000;
          }
          {
            id = "google/gemini-3-flash-preview";
            name = "Gemini 3 Flash";
            contextWindow = 1048576;
            maxTokens = 1048576;
          }
          {
            id = "google/gemini-3-pro-preview";
            name = "Gemini 3 Pro";
            contextWindow = 1048576;
            maxTokens = 1048576;
          }
          {
            id = "gemini-3-pro-preview";
            name = "Gemini 3 Pro (short)";
            contextWindow = 1048576;
            maxTokens = 1048576;
          }
          {
            id = "google/gemini-2.5-flash";
            name = "Gemini 2.5 Flash";
            contextWindow = 1048576;
            maxTokens = 1048576;
          }
          {
            id = "google/gemini-2.5-pro";
            name = "Gemini 2.5 Pro";
            contextWindow = 1048576;
            maxTokens = 1048576;
          }
        ];
      };
    };
  };
}

{ inputs }:
{
  "$schema" = "https://opencode.ai/config.json";
  autoupdate = false;
  provider = {
    new-api = {
      npm = "@ai-sdk/openai-compatible";
      name = "New API";
      options = {
        baseURL = "{env:OPENCODE_BASE_URL}";
        apiKey = "{env:OPENCODE_API_KEY}";
      };
      models = {
        deepseek-v4-pro-max = {
          name = "deepseek-v4-pro";
          limit = {
            context = 1048576;
            output = 384000;
          };
        };
        deepseek-v4-flash = {
          name = "deepseek-v4-flash";
          limit = {
            context = 1048576;
            output = 384000;
          };
        };
        "deepseek-ai/DeepSeek-V4-Flash" = {
          name = "deepseek-ai/DeepSeek-V4-Flash";
          limit = {
            context = 1048576;
            output = 384000;
          };
        };
        "deepseek/deepseek-v4-pro" = {
          name = "deepseek/deepseek-v4-pro";
          limit = {
            context = 1048576;
            output = 384000;
          };
        };
        "deepseek/deepseek-v4-flash" = {
          name = "deepseek/deepseek-v4-flash";
          limit = {
            context = 1048576;
            output = 384000;
          };
        };
        "deepseek/deepseek-v3.2" = {
          name = "deepseek/deepseek-v3.2";
          limit = {
            context = 163840;
            output = 163840;
          };
        };
        "Pro/deepseek-ai/DeepSeek-V3.2" = {
          name = "deepseek-ai/DeepSeek-V3.2";
          limit = {
            context = 163840;
            output = 163840;
          };
        };
        "minimax/minimax-m2.1" = {
          name = "minimax/minimax-m2.1";
          limit = {
            context = 204800;
            output = 204800;
          };
        };
        "x-ai/grok-4.1-fast" = {
          name = "x-ai/grok-4.1-fast";
          limit = {
            context = 2000000;
            output = 2000000;
          };
        };
        "google/gemini-3-flash-preview" = {
          name = "google/gemini-3-flash-preview";
          limit = {
            context = 1048576;
            output = 1048576;
          };
        };
        "google/gemini-3-pro-preview" = {
          name = "google/gemini-3-pro-preview";
          limit = {
            context = 1048576;
            output = 1048576;
          };
        };
        "gemini-3-pro-preview" = {
          name = "gemini-3-pro-preview";
          limit = {
            context = 1048576;
            output = 1048576;
          };
        };
        "google/gemini-2.5-flash" = {
          name = "google/gemini-2.5-flash";
          limit = {
            context = 1048576;
            output = 1048576;
          };
        };
        "google/gemini-2.5-pro" = {
          name = "google/gemini-2.5-pro";
          limit = {
            context = 1048576;
            output = 1048576;
          };
        };
        "gemini-3.1-pro-preview" = {
          name = "gemini-3.1-pro-preview";
          limit = {
            context = 1048576;
            output = 1048576;
          };
        };
      };
    };
  };
  permission = {
    edit = "allow";
    bash = {
      rm = "ask";
      "rm*" = "ask";
      "rm *" = "ask";
      "*" = "allow";
    };
  };

  mcp = {
    "codebase-memory-mcp" = {
      enabled = true;
      type = "local";
      command = [
        "${inputs.codebase-memory-mcp.packages.x86_64-linux.default}/bin/codebase-memory-mcp"
      ];
    };
  };
}

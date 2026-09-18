{
  pkgs,
  inputs,
  ...
}:
{
  "$schema" = "https://opencode.ai/config.json";
  autoupdate = false;
  model = "new-api/deepseek-flash";
  small_model = "new-api/glm-5.3-flash";
  provider = {
    new-api = {
      npm = "@ai-sdk/openai-compatible";
      name = "New API";
      options = {
        baseURL = "{env:OPENCODE_BASE_URL}";
        apiKey = "{env:OPENCODE_API_KEY}";
      };
      models = {
        "deepseek-flash" = {
          name = "deepseek-flash";
          limit = {
            context = 1048576;
            output = 384000;
          };
          attachment = true; # 视觉模型：支持图片附件
          modalities = {
            input = [
              "text"
              "image"
            ];
            output = [ "text" ];
          };
        };
        "gemini-3.1-pro-preview" = {
          name = "gemini-3.1-pro-preview";
          limit = {
            context = 1048576;
            output = 1048576;
          };
        };
        "glm-5.3-flash" = {
          name = "glm-5.3-flash";
          limit = {
            context = 1000000;
            output = 131076;
          };
          attachment = true; # 视觉模型：支持图片附件
          modalities = {
            input = [
              "text"
              "image"
            ];
            output = [ "text" ];
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
        "${
          inputs.codebase-memory-mcp.packages.${pkgs.stdenv.hostPlatform.system}.default
        }/bin/codebase-memory-mcp"
      ];
    };
  };
}

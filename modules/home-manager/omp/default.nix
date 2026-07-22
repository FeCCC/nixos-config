{
  pkgs,
  config,
  inputs,
  ...
}:
let
  omp-pkg = inputs.omp-nix.packages.${pkgs.stdenv.hostPlatform.system}.default;

  omp-wrapped = pkgs.writeShellScriptBin "omp" ''
    export PI_CODING_AGENT_DIR="${config.xdg.configHome}/omp/agent"
    export OPENAI_API_KEY=$(cat "${config.sops.secrets.new_api_key.path}")
    export JS_DEBUG_DAP_SERVER="${pkgs.vscode-js-debug}/lib/node_modules/js-debug/dist/src/dapDebugServer.js"
    # LSP + DAP 工具仅对 omp 进程注入 PATH，不污染 home-manager
    export PATH="${
      pkgs.lib.makeBinPath [
        pkgs.clang-tools # clangd — C/C++ 语言服务
        pkgs.rust-analyzer # rust-analyzer — Rust 语言服务
        pkgs.basedpyright # basedpyright-langserver — Python 语言服务
        pkgs.typescript-language-server # typescript-language-server — JS/TS 语言服务
        pkgs.lldb # lldb-dap — C/C++/Rust 调试器
        (pkgs.python3.withPackages (ps: [ ps.debugpy ])) # debugpy — Python 调试器
      ]
    }:$PATH"
    exec "${omp-pkg}/bin/omp" "$@"
  '';

  yamlFormat = pkgs.formats.yaml { };

  # ── 应用配置 (config.yml) ──
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

  # ── 模型/供应商定义 (models.json) ──
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
in
{
  home.packages = [ omp-wrapped ];

  sops.secrets.new_api_key = { };

  sops.secrets.new_api_base_url_for_openai = { };

  xdg.configFile = {
    "omp/agent/config.yml".source = yamlFormat.generate "omp-config.yml" appConfig;
    "omp/agent/mcp.json".text = builtins.toJSON {
      mcpServers.codebase-memory-mcp = {
        type = "stdio";
        command = "${
          inputs.codebase-memory-mcp.packages.${pkgs.stdenv.hostPlatform.system}.default
        }/bin/codebase-memory-mcp";
      };
    };
    # skills — superpowers + cc-skills 合并
    "omp/agent/skills" = {
      source = pkgs.symlinkJoin {
        name = "omp-skills-merged";
        paths = [
          (inputs.superpowers + "/skills")
          (inputs.cc-skills + "/skills")
        ];
      };
      recursive = true;
    };
    "omp/agent/AGENTS.md".text = ''
      ## Code Search — Use MCP Codebase Memory

      When you need to find where a function is defined, who calls it,
      what depends on it, or any structural code question, ALWAYS use
      the `codebase-memory-mcp` tools FIRST:

      - search_graph — find functions/classes/routes by name or keyword
      - search_code  — graph-augmented grep (deduplicates, ranks by importance)
      - trace_path   — trace callers/callees/data flow
      - get_code_snippet — read source of a specific symbol
      - query_graph  — complex Cypher multi-hop queries
      - get_architecture — high-level project overview

      DO NOT use grep, rg, find, or ls to search code — these only
      see raw text and miss structural relationships. Only fall back
      to grep if codebase-memory returns an error or empty result
      after trying different search terms.

      ## Index Freshness

      The codebase-memory index does not auto-update after git commits.
      Always run a fast re-index before your first search of the session:

        index_repository(repo_path="<project_root>", mode="fast")
    '';
  };

  sops.templates."omp-models" = {
    path = "${config.xdg.configHome}/omp/agent/models.json";
    content = builtins.toJSON modelsConfig;
  };
}

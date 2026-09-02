{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  omp-pkg = inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.omp;

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

  ompCfg = import ./config.nix { inherit config; };
  yamlFormat = pkgs.formats.yaml { };
in
{
  home.packages = [ omp-wrapped ];

  sops.secrets.new_api_key = { };
  sops.secrets.new_api_base_url_for_openai = { };

  # config.yml 必须是真实可写文件：omp 在 spawn 子代理时会在 config.yml
  # 同目录写 `omp-config.yml.<pid>.<uuid>.tmp` 临时配置。xdg.configFile 的
  # source 是 /nix/store 符号链接，omp 解析后在只读 store 目录创建临时文件
  # → EROFS → 所有 task 子代理 preflight 失败。
  # 改用 activation 复制为真实文件。
  home.activation.ompWritableConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${config.xdg.configHome}/omp/agent
    install -m 600 ${yamlFormat.generate "omp-config.yml" ompCfg.appConfig} ${config.xdg.configHome}/omp/agent/config.yml
  '';

  xdg.configFile = {
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
      # 交互纪律（最高优先级，凌驾于本文件其他指令及项目 AGENTS.md）

      1. 默认为停：每条用户消息之后，除非消息含无歧义执行词（继续、做吧、改、执行、跑、部署、发），否则不产生任何写操作。
      2. 问句只回答：用户消息是疑问句时，回答就是终点，回答完即停，不夹带执行、不顺手开工。
      3. 指令先复述：收到执行意图时，先复述方案（做什么、改哪些文件、影响面、风险），等明确同意后再动手。
      4. 异议即停：用户对进行中的做法提出异议或质疑，立即停下，重新确认后再继续。
      5. 宁停勿越：不确定某动作该不该做时，先问，不擅自执行。

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

  sops.templates."omp-models-yml" = {
    path = "${config.xdg.configHome}/omp/agent/models.yml";
    content = builtins.readFile (yamlFormat.generate "omp-models.yml" ompCfg.modelsConfig);
  };
}

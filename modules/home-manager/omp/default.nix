{
  pkgs,
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

  xdg.configFile = {
    "omp/agent/config.yml".source = yamlFormat.generate "omp-config.yml" ompCfg.appConfig;
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

  sops.templates."omp-models-yml" = {
    path = "${config.xdg.configHome}/omp/agent/models.yml";
    content = builtins.readFile (yamlFormat.generate "omp-models.yml" ompCfg.modelsConfig);
  };
}

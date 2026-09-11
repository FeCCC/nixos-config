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
    "omp/agent/AGENTS.md".source = ./AGENTS.md;
    "omp/agent/RULES.md".source = ./RULES.md;
  };

  sops.templates."omp-models-yml" = {
    path = "${config.xdg.configHome}/omp/agent/models.yml";
    content = builtins.readFile (yamlFormat.generate "omp-models.yml" ompCfg.modelsConfig);
  };
}

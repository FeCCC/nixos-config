## opencode 专属

- codebase-memory 工具调用一律带 `format="json"`，结构化输出稳定可解析。
  例：`search_graph(project="X", query="keyword", format="json", limit=10)`。

### 子代理委派（CLI）

opencode 的 explore / scout 子代理没有 MCP 工具权限，但 codebase-memory-mcp
在 PATH 上。委派代码探查时把下面这段原样带上：

  "codebase-memory-mcp is on PATH. Use it for code search.

   列出项目：
     codebase-memory-mcp cli list_projects

   检索前刷新索引：
     codebase-memory-mcp cli index_repository --repo-path /path --name NAME --mode fast

   按符号搜索：
     codebase-memory-mcp cli search_graph --project NAME --query keyword --limit 10

   图增强的文本搜索：
     codebase-memory-mcp cli search_code --project NAME --pattern regex --limit 10

   追踪调用方与被调用方：
     codebase-memory-mcp cli trace_path --project NAME --function-name Func --direction both --depth 3

   读符号源码：
     codebase-memory-mcp cli get_code_snippet --project NAME --qualified-name pkg.Func

   字面量（字符串、配置项路径、依赖名）用 grep，图里没有这些节点。"

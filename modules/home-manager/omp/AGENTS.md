# Code Search — codebase-memory-mcp

- 每次调用都要带 `project`；名字先用 `list_projects` 取。
- 参数以 `read xd://<tool>` 返回的 schema 为准，不要照描述猜字段名。
- 结构/符号查询（函数、类、路由、调用关系）→ `search_graph`、
  `trace_path`、`get_code_snippet`；全局概览 → `get_architecture`；
  多跳关系 → `query_graph`。
- 字面量检索（字符串、配置项路径、依赖名）→ 用 `grep`，不要在图上找。
- 配置/DSL 类仓库（Nix、YAML、Terraform…）通常只建文件/符号级节点，
  调用关系不可用：不要用图回答"谁调用了它、什么依赖它"，更不要据此
  断言"没有依赖"。
- 仓库里的 Markdown（AGENTS.md 等）也会进图，检索时用 `file_pattern` /
  `label` 收窄。
- 分页看 `total_relation`：`eq` 是精确计数；`gte` 表示撞到引擎上限，
  用 `cursor` 继续。
- 引用图里的路径前，用 `check_index_coverage` 校验。
- 判断索引是否过期看 `index_status` 的 `indexed_at`；commit 后重跑
  `index_repository(repo_path="<root>", mode="fast")`。
- `fast` 不含语义层（`semantic_query` 不可用）；语义检索用 `moderate`
  或 `full`。
- 索引有缺口：skip-list 文件（lock 等）不收，解析失败的文件行号不可用，
  这类文件直接读源文件。

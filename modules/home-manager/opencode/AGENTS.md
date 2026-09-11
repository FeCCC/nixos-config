## Code Search — codebase-memory-mcp

- Every call needs `project`; get the name from `list_projects` first.
- Structural/symbol lookups (functions, classes, routes, call relations) →
  `search_graph`, `trace_path`, `get_code_snippet`; overview →
  `get_architecture`; multi-hop → `query_graph`.
- Literal lookups (strings, config paths, dependency names) → use `grep`.
  The graph has no nodes for these, so searching it is wasted work.
- Config/DSL repos (Nix, YAML, Terraform, …) usually only get file/symbol-level
  nodes and no usable call relations: do not use the graph to answer "who calls
  this / what depends on it", and do not conclude "nothing depends on it".
- Repo Markdown (AGENTS.md, …) gets indexed too and pollutes keyword search —
  narrow with `file_pattern` / `label`.
- Paginate on `total_relation`: `eq` is an exact count; `gte` means the engine
  ceiling was hit — continue with `cursor`.
- Verify paths taken from the graph with `check_index_coverage` before citing
  them.

Always pass `format="json"` to codebase-memory tools — the structured output is
stable and parseable. Example calls:

  search_graph(project="X", query="keyword", format="json", limit=10)
  trace_path(project="X", function_name="F", format="json", depth=3)
  get_architecture(project="X", format="json")
  query_graph(project="X", query="...", format="json")

## Index Freshness

`index_status` reports `indexed_at` — check it to judge staleness. After commits,
re-index before searching:

  index_repository(repo_path="<project_root>", mode="fast")

Fast mode skips the semantic layer (`semantic_query` is unavailable). Use
`mode="full"` after large refactors that change call-graph topology, and for any
semantic search.

Missing coverage is normal and not an error: skip-listed files (lock files, …)
are excluded, and files that fail to parse have no usable line ranges — read
those from source instead.

## Sub-agents — CLI Codebase Memory

The explore and scout sub-agents do NOT have MCP tool access, but
codebase-memory-mcp is installed as a CLI. When delegating code exploration to a
sub-agent, include these instructions verbatim:

  "codebase-memory-mcp is on PATH. Use it for code search.

   Discover available projects:
     codebase-memory-mcp cli list_projects

   Refresh the index before searching:
     codebase-memory-mcp cli index_repository --repo-path /path --name NAME --mode fast

   Search for symbols:
     codebase-memory-mcp cli search_graph --project NAME --query keyword --limit 10

   Graph-augmented text search:
     codebase-memory-mcp cli search_code --project NAME --pattern regex --limit 10

   Trace callers and callees:
     codebase-memory-mcp cli trace_path --project NAME --function-name Func --direction both --depth 3

   Read source of a symbol:
     codebase-memory-mcp cli get_code_snippet --project NAME --qualified-name pkg.Func

   For literals (strings, config paths, dependency names) use grep instead —
   the graph has no nodes for those."

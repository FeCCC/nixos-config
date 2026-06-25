## Code Search — Use MCP Codebase Memory

When you need to find where a function is defined, who calls it,
what depends on it, or any structural code question:

  ALWAYS use codebase-memory tools FIRST:
  - search_graph → find functions/classes/routes by name or keyword
  - search_code  → graph-augmented grep (deduplicates, ranks by importance)
  - trace_path   → trace callers/callees/data flow
  - get_code_snippet → read source of a specific symbol
  - query_graph  → complex Cypher multi-hop queries

  DO NOT use grep, rg, find, or ls to search code — these only
  see raw text and miss structural relationships.

  Only fall back to grep if codebase-memory returns an error or
  empty result after you have tried different search terms.

### Index Freshness

The codebase-memory index does not auto-update after git commits.
To guarantee results reflect the latest code, always run a fast
re-index before your first search of the session:

  index_repository(repo_path="<project_root>", mode="fast")

Fast mode skips similarity/semantic edges and refreshes only
file-to-symbol mappings (~30s). Use mode="full" after large
refactors that change the call graph topology.

### Sub-agents — CLI Codebase Memory

The explore and scout sub-agents do NOT have MCP tool access, but
codebase-memory-mcp is installed as a CLI. When delegating code
exploration to a sub-agent, include these instructions verbatim:

  "codebase-memory-mcp is on PATH. Use it for ALL code search.

   Discover available projects:
     codebase-memory-mcp cli list_projects

   Refresh the index before searching:
     codebase-memory-mcp cli index_repository '{"project":"NAME","repo_path":"/path","mode":"fast"}'

   Search for symbols:
     codebase-memory-mcp cli search_graph '{"project":"NAME","query":"keyword","limit":10}'

   Graph-augmented text search:
     codebase-memory-mcp cli search_code '{"project":"NAME","pattern":"regex","limit":10}'

   Trace callers and callees:
     codebase-memory-mcp cli trace_path '{"project":"NAME","function_name":"Func","direction":"both","depth":3}'

   Read source of a symbol:
     codebase-memory-mcp cli get_code_snippet '{"project":"NAME","qualified_name":"pkg.Func"}'

   DO NOT use grep, rg, find, or ls for code search."

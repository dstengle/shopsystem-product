@bc:shopsystem-bc-launcher @origin:lead-3zzu
Feature: the fabro dispatcher's dispatch step is an ACP-backed script-agent node (backend="acp"), not a native command node, so the dispatch step receives the incoming context and returns structured dispatch decisions (lead-3zzu, Scenario A)

  DRIVER (lead-3zzu, David 2026-07-08): the native poll-loop dispatcher
  (lead-b3f0) works, but its native command "dispatch" node is context-blind —
  it acts on the raw pending work ids each cycle with no memory of what it
  already spawned. David's fix replaces that node with an ACP-backed SCRIPT
  AGENT ("backend=acp", "acp.command=python3 <dispatch_acp_agent.py>" or
  "acp.config" JSON stdio; fabro implements ACP via the agent-client-protocol
  crate), because the ACP agent node RECEIVES the incoming context (pending
  inbox + in-flight run state) and RETURNS structured decisions — the property
  the limited native command node lacks and the property the idempotency and
  work_id-delivery behaviors (Scenarios B and C) depend on.

  FIDELITY: the step defs inspect the REAL poured "dispatcher.fabro" def graph
  — the "dispatch" node's kind and attrs (backend="acp" with an
  "acp.command"/"acp.config" attr, NOT a native "script="/parallelogram command
  node) and its context-in / decisions-out wiring — read against the fabro-def
  artifact surface, NOT a live container run. The ACP wire protocol internals
  (JSON-RPC initialize/session/new/session/prompt) are the BC's build and are
  NOT pinned here; this scenario pins the NODE KIND on the artifact surface.

  @scenario_hash:7709a671bdfaddb7
  Scenario: the poured dispatcher's dispatch node is an ACP-backed agent node carrying backend="acp" and an acp.command or acp.config attr, wired to receive the poll context and return dispatch decisions, not a native command node
    Given the shopsystem-bc-launcher BC is installed
    And the container "bc-shopsystem-messaging" is running with the self-contained fabro def set POURED by shop-templates into "/workspace/.fabro/", including the "dispatcher.fabro" graph def the "dispatcher.toml" entrypoint applies
    When the poured "dispatcher.fabro" def's "dispatch" node is inspected structurally, without a live docker daemon, a running fabro server, or a reachable agent-vault
    Then the "dispatch" node is an ACP-backed AGENT node carrying "backend=acp" together with an "acp.command" attr (a shell such as "python3 <dispatch_acp_agent.py>") OR an "acp.config" attr (a JSON stdio config), so fabro drives it through the agent-client-protocol backend
    And the "dispatch" node is NOT a native "script="/parallelogram command node, so the pre-fix context-blind command dispatch is absent
    And the "dispatch" node is wired to RECEIVE the incoming context yielded by the "poll" node — the pending inbox work ids plus the in-flight run state — as its input
    And the "dispatch" node is wired to RETURN structured dispatch DECISIONS as its output, which the loop consumes to spawn children, so the dispatch step both reads context and emits decisions rather than blindly re-acting on raw work ids each cycle

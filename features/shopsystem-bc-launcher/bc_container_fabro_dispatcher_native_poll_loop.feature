@bc:shopsystem-bc-launcher @origin:lead-b3f0
Feature: the fabro dispatcher def is a cyclic poll-loop (poll -> dispatch -> wait -> back-edge) with no long-running watch node and no LLM in the loop, its only agent node being the NON-LLM ACP dispatch script-agent (lead-b3f0 Scenario B, reconciled to the ADR-058 2nd-amendment ACP dispatch node — lead-4uo1/lead-3zzu)

  VALIDATED by the lead's in-container empirical verification (lead-b3f0,
  2026-07-08): the long-running "shop-msg watch" node plus the Haiku "launch"
  agent node in the ADR-058 dispatcher existed ONLY to feed Claude's Monitor —
  they are unnecessary under the fabro engage. The validated redesign replaces
  them with a cyclic poll-loop whose poll and wait nodes are native "script="
  nodes and whose dispatch node is a NON-LLM ACP script-agent (ADR-058 2nd
  amendment, lead-3zzu): it carries NO LLM/model-backed node in the loop, so
  the steady-state loop spends ZERO model tokens — not because there is no
  agent node, but because its only agent node is a non-LLM ACP script (Fabro
  injects no model creds). Tokens are spent only on the child's actual work,
  never on polling or dispatch. This SUPERSEDES ADR-058's "start ->
  watch(native) -> launch(Haiku) -> back-edge" design; flag ADR-058 for
  amendment.

  FIDELITY: the step defs inspect the REAL poured "dispatcher.fabro" def graph
  topology — the cyclic "poll -> dispatch -> wait -> poll" back-edge, the poll
  and wait nodes each being a native "script=" node, the dispatch node being
  the NON-LLM ACP script-agent node (backend=acp), the ABSENCE of any
  long-running "shop-msg watch" node, and the ABSENCE of any LLM/model-backed
  node anywhere in the loop — read against the fabro-def artifact surface, NOT
  a live container run. Runtime cyclic execution is BC-proven in-container
  (lead-b3f0); the def-contract shape is what this scenario pins on the
  artifact surface.

  @scenario_hash:f52fa60bb69f73d1
  Scenario: the poured dispatcher def is a cyclic poll-loop with poll and wait as native script nodes and dispatch as the non-LLM ACP script-agent node, a back-edge from wait to poll, no long-running watch node, and no LLM node in the loop
    Given the shopsystem-bc-launcher BC is installed
    And the container "bc-shopsystem-messaging" is running with the self-contained fabro def set POURED by shop-templates into "/workspace/.fabro/", including the "dispatcher.fabro" graph def the "dispatcher.toml" entrypoint applies
    When the poured "dispatcher.fabro" def is inspected structurally, without a live docker daemon, a running fabro server, or a reachable agent-vault
    Then the "dispatcher.fabro" is a CYCLIC graph whose loop is "start -> poll -> dispatch -> wait -> poll", the "wait -> poll" edge being the BACK-EDGE that forms the cycle, so the run persists by cycling poll->dispatch->wait->poll rather than blocking on a single long-running watch
    And the "poll" node is a NATIVE "script=" node with no LLM that lists the current pending inbox via "shop-msg pending inbox --bc shopsystem-messaging" and yields the concrete pending work ids, returning promptly rather than blocking
    And the "dispatch" node is the NON-LLM ACP script-agent node (backend=acp with acp.command/acp.config, a non-LLM script that receives context and returns decisions, NOT a model-backed agent) that acts on the pending work ids from "poll"
    And the "wait" node is a NATIVE "script=" node with no LLM that sleeps a short interval before the back-edge returns to "poll"
    And the def contains NO long-running "shop-msg watch" node and NO LLM/model-backed node anywhere in the loop — the ONLY agent node is the NON-LLM ACP "dispatch" script-agent — so the steady-state loop consumes ZERO model tokens because the ACP dispatch agent is a non-LLM script (Fabro injects no model creds), and tokens are spent only on the child's actual work

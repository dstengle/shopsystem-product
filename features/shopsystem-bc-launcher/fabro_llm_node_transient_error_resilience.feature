@bc:shopsystem-bc-launcher @origin:lead-6ev8
Feature: a fabro LLM/ACP agent node RETRIES a transient infra error (429 rate-limit, 5xx, connection reset) with bounded exponential backoff and SURVIVES a transient burst — completing to a real gated work_done when capacity returns — instead of failing-fast to the content-free failsafe on the first transient error, matching the tmux claude agent's resilience (lead-6ev8)

  ROOT CAUSE (lead-6ev8, P1, empirical 2026-07-14, dogfood run
  01KXF5XB24R1RXDX4KEESVVC53, shopsystem-templates on --orchestrator fabro): a
  real finite fabro run executed ALL native (non-LLM) nodes successfully —
  prime, work-tracker health gate, arm/drain inbox, read message — then DIED at
  the FIRST LLM node "bc-router classify" with "Error: LLM error: Rate limited
  by anthropic". The anthropic-oauth-shim log for the run showed "POST
  /v1/messages 200" (ONE success — so auth / agent-vault / proxy / oauth ALL
  WORK) then "429 x4"; the workflow node ran with max_attempts=1, so the LLM
  path had NO workflow-level retry budget and FAILED-FAST on a transient 429,
  emitting the content-free failsafe block after ~14s. A tmux claude agent
  survives identical 429s (Claude Code CLI has long robust 429 backoff), which
  is why tmux completed the same class of work where fabro blocked. This is a
  RUNTIME-PARITY RESILIENCE gap, not a fabro-substrate defect: the substrate
  (engage, graph, native nodes, oauth) is sound; the sole blocker to
  substantive fabro work is that the LLM/ACP path does not retry transient infra
  errors with robust backoff.

  WHAT THESE PIN: a fabro LLM/ACP agent node that receives a TRANSIENT infra
  error (429 rate-limit, and by extension 5xx / connection reset) RETRIES with
  bounded exponential backoff (max_attempts > 1, spaced retries, capped total
  wait) and, when capacity returns within the retry budget, SUCCEEDS and the run
  continues to a real gated work_done — it does NOT fail-fast to the failsafe on
  the first transient error. The resilience posture matches the tmux claude
  agent: a transient rate-limit a tmux run survives, a fabro run also survives.

  RELATION TO THE OBSERVABILITY SET (lead-01jw.3, same directory,
  fabro_diagnostic_blocked_work_done): those scenarios pin how an
  EXHAUSTED-retry / persistent failure is REPORTED — the infra-path /
  rate-limit-429 diagnostic block (@scenario_hash:738f35759127fe7f
  Examples row "rate-limit-429", and @scenario_hash:629be1e0224f3a03 the
  diagnostic triple). THESE scenarios pin the RETRY-AND-SURVIVE behavior BEFORE
  that report: retries happen, the run survives a transient burst, backoff is
  spaced, parity holds. They EXTEND rather than contradict: the diagnostic block
  is now reached ONLY AFTER a bounded retry effort is exhausted, NOT on the first
  transient error — which is precisely the regression lead-6ev8 closes. The
  runtime-parity keystone here mirrors the shape of the observability parity pin
  (@scenario_hash:8af4e27a05ae9a32) and the liveness parity pin
  (fabro_liveness_heartbeat_parity, @scenario_hash:81eee7115a2457f4).

  FIDELITY (ADR-018): retry occurrence, backoff spacing, burst survival, and the
  terminal work_done outcome are DYNAMIC runtime outcomes surfaced via the
  shop-msg mailbox and the fabro run / oauth-shim runtime logs, not lead-side
  reads of BC source. These are BC-DEMONSTRATED in-container — a real finite
  "fabro run workflow.fabro" child driven through a transient-error burst against
  the real shared server — and asserted against the real work_done row on the
  shop-msg surface and the observable retry/backoff trace, never against BC
  source and never against a model.

  @scenario_hash:3b3cf899ddd8ed68
  Scenario: a fabro LLM/ACP node survives a transient 429 burst — it retries and completes to a real gated work_done rather than failing-fast to the failsafe on the first transient error
    Given the container "bc-shopsystem-messaging" is running the "--orchestrator fabro" watcher engage with its single long-lived shared per-container fabro server
    And an inbound message carrying a work_id on a scenario path fires one finite "fabro run workflow.fabro" child whose graph reaches an LLM/ACP agent node such as "bc-router classify"
    And the model provider returns a BURST of transient 429 rate-limit responses on that node's first model calls and then returns to serving capacity within the node's retry budget
    When the finite child runs that LLM/ACP node through the transient burst
    Then the LLM/ACP node RETRIES the transient error rather than terminating on the first 429 — its workflow-level retry semantics are max_attempts > 1, so a single transient error is not terminal
    And once the provider returns to capacity within the retry budget, the node SUCCEEDS on a subsequent attempt and the run CONTINUES past that node rather than stopping there
    And the run proceeds to its terminal work_done as a REAL gated outcome — status "complete" for a produced-and-gated deliverable, or a substantive clarify/block from the deliverable path — NOT the content-free failsafe block emitted after ~14s on the first 429 that lead-6ev8 observed
    And the negative control holds: a max_attempts=1 node with no retry budget would have failed-fast to the failsafe on the first 429, which is the lead-6ev8 regression this behavior closes

  @scenario_hash:088460f2fd9490a4
  Scenario: the LLM/ACP node's retries use bounded exponential backoff — spaced, count-bounded, and total-wait-bounded — so the client does not amplify the 429 with an immediate retry-storm
    Given the container "bc-shopsystem-messaging" is running the "--orchestrator fabro" watcher engage with its single long-lived shared per-container fabro server
    And a finite "fabro run workflow.fabro" child reaches an LLM/ACP agent node whose model calls are met with repeated transient 429 rate-limit responses
    When the node retries the transient error across successive attempts
    Then the delay BETWEEN successive retry attempts INCREASES from one attempt to the next — exponential backoff — rather than retrying immediately at a fixed zero-or-tiny interval that would hammer the provider
    And the growing backoff delay is CAPPED at a maximum per-attempt ceiling, so the interval increases but does not grow unboundedly
    And the retry count is BOUNDED — the node attempts a finite number of times, not indefinitely — and the cumulative wait across all retries is BOUNDED by a total retry-budget ceiling, so the node cannot hang the run forever waiting on a persistently-unavailable provider
    And because the retries are spaced by increasing backoff rather than fired immediately, the client does not itself amplify the rate-limit into a self-inflicted retry-storm against the shared account

  @scenario_hash:acd8d90bd9d4e4df
  Scenario: the fabro LLM path's transient-error resilience matches the tmux claude agent's — a transient rate-limit a tmux run survives, a fabro run also survives, and the operator sees the same completion outcome regardless of runtime
    Given a tmux-engaged claude BC processing substantive work hits the same transient 429 rate-limit burst and, via Claude Code's long robust 429 backoff, survives it and drives the work to a real gated completion
    And a fabro-engaged BC processing that same substantive work hits the same transient 429 rate-limit burst on its LLM/ACP node
    When each runtime processes the same substantive work across the same transient rate-limit burst that resolves within a survivable window
    Then the fabro run SURVIVES the transient burst exactly as the tmux run does — it retries with bounded exponential backoff and completes to a real gated work_done — rather than blocking opaquely on the first 429 as the pre-fix fabro run did (lead-6ev8)
    And the operator sees the SAME completion outcome from either runtime for the same survivable transient burst — the work_id reconciles to a real gated result on both — so a transient rate-limit does not decide whether the work gets done based on which runtime ran it
    And this closes the lead-01jw.3 facet-2 gap where tmux completed lead-ew86 (a substantive request_bugfix) while fabro blocked on the identical class of transient 429, because the two runtimes now share the same transient-error resilience posture

  @scenario_hash:591515631f39c311
  Scenario: when transient errors PERSIST beyond the retry budget, the run blocks only AFTER a bounded retry effort — the terminal report is the infra-path / rate-limit-429 diagnostic already pinned, not a first-error fail-fast
    Given the container "bc-shopsystem-messaging" is running the "--orchestrator fabro" watcher engage with its single long-lived shared per-container fabro server
    And a finite "fabro run workflow.fabro" child reaches an LLM/ACP agent node whose model provider returns transient 429 rate-limit responses that PERSIST for longer than the node's entire retry budget
    When the node exhausts its bounded retry effort — multiple spaced attempts under exponential backoff — without the provider returning to capacity
    Then the node reaches exhaustion ONLY AFTER that bounded retry effort — the multiple spaced attempts DID occur — rather than terminating on the first transient error as the pre-fix max_attempts=1 path did
    And only at exhaustion does the run block and emit its terminal blocked work_done, whose REPORTING behavior is the infra-path / rate-limit-429 DIAGNOSTIC already pinned by fabro_diagnostic_blocked_work_done (@scenario_hash:738f35759127fe7f Examples row reason_class "infra-path" / detail_marker "rate-limit-429", carrying the failing node and captured context per @scenario_hash:629be1e0224f3a03) — this scenario does NOT re-pin that reporting behavior, it references it by value
    And the distinction this pins is temporal-and-behavioral: the diagnostic block is now the END of a bounded retry effort, not the response to a single transient error, so exhaustion is a genuine capacity failure rather than a fail-fast

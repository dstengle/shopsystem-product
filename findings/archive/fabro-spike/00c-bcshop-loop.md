# Fabro Spike — Slice 0 Recon, Leg C: what the fabro-orchestrated loop must RECREATE

Scope: inventory, from the ARTIFACT/CONTRACT surface only (no BC source on this
lead host, ADR-018), the three things a fabro-orchestrated BC loop must
reproduce:

1. the bc-shop loop (Implementer → Reviewer, gated, emitting `work_done`);
2. the `bc-container` / `bc-launcher` launch interface a fabro launcher must match
   (launch-interface parity);
3. the `shop-templates` "furniture" (role prompts, workflow/skill definitions,
   gating rules) that would need translating into fabro's workflow format.

All claims are cited to a file or command on the artifact surface. Items that
could NOT be determined here (would need the BC to report via mailbox) are
flagged `[UNRESOLVED]`.

---

## Section 1 — The bc-shop loop: steps, gates, and the work_done emission

### 1.0 Where the loop is defined (the furniture)

The loop is NOT BC-private code — it is defined entirely in the `shop-templates`
package furniture that `bc-container launch` pours into each BC (`features/bc-launcher/43-...gherkin`).
Concretely it lives in three template families under
`/usr/local/lib/python3.11/site-packages/shop_templates/templates/`:

- `claude/bc.md` + `claude_body/bc.md` + `claude_settings/bc.json` — the BC
  shop's `CLAUDE.md` assembly and `.claude/settings.json` (session-start hooks).
- `bc-implementer.md`, `bc-reviewer.md` — the two role subagent definitions
  (also exported via `shop-templates show bc-implementer|bc-reviewer`).
- `skills/` — the composable skill-group: `bc-router`, `bc-sufficiency-check`,
  `writing-plans-bdd`, `subagent-driven-development`, `test-driven-development`,
  `using-git-worktrees`, `integrating-to-main`, `bc-review`, `work-done-gate`
  (+ `po-architect-decomposition-exchange`). Listed by `ls .../templates/skills/`.

The router itself is the **`bc-router` skill** (`skills/bc-router/SKILL.md`) —
there is NO `bc-router.md` subagent template; the router IS the top-level BC
agent, which loads the skill. Only two subagents exist: `bc-implementer` and
`bc-reviewer` (`ls .../templates/*.md`; `claude/bc.md` "Who you are").

### 1.1 Session-start sequence (every BC session)

From `claude/bc.md` "YOUR FIRST ACTION on every session" and `bc-router`
SKILL "Step-by-Step Protocol":

1. Load the `bc-router` skill.
2. `shop-msg prime --bc <name>` — DSN reachability, pending-inbox count.
3. `bd prime` — beads workflow context.
4. **Work-tracker health step (GATES the role loop).** Tracker is *healthy*
   only when ALL of: `bd create` exits zero yielding an id under the configured
   `issue_prefix` (local writability), `bd ready` exits zero, AND a **test
   `dolt push`** to the configured Dolt remote exits zero (remote writability).
   - Heal path (unprovisioned-but-recoverable): empty working set + no configured
     prefix BUT committed registry names a definite `issue_prefix` and ≥1 issue →
     ADOPT the committed prefix (NOT derived from BC name) and IMPORT committed
     issues preserving original ids, then re-validate.
   - Block path (unhealable): empty working set + no prefix + committed registry
     names none → surface a work-tracker health FAILURE at session-start; BC does
     NOT begin its role loop and emits no role work.
   - Block path (remote-unwritable): locally writable but the test `dolt push`
     exits non-zero → report unhealthy naming the failed push; role loop blocked.
   Detection is deliberately pulled forward to session-start (never at
   `work_done` time). Source: `claude/bc.md` "Session-start work-tracker health
   step"; `bc-router` SKILL "Session-start work-tracker health step".
   `.claude/settings.json` SessionStart hooks run `bd prime` and `shop-msg prime`
   (`claude_settings/bc.json`).
5. Arm the in-session **Monitor** on `shop-msg watch --bc <name>` (postgres
   LISTEN/NOTIFY; one line per new inbox message). Not a SessionStart hook.
6. Drain pending inbox — the role loop: `shop-msg pending inbox --bc <name>`;
   for each row the router classifies + dispatches (below).

### 1.2 The classification table (router intake → dispatch)

From `bc-router` SKILL "Classification Table" and `claude/bc.md`:

| message_type | scenarios? | dispatch path | who emits work_done |
|---|---|---|---|
| `assign_scenarios` | yes (required) | implementer → reviewer gate | **reviewer** |
| `request_bugfix` | non-empty | implementer → reviewer gate | **reviewer** |
| `request_bugfix` | empty | implementer only | **implementer** |
| `request_maintenance` | n/a | implementer only | **implementer** |

`mechanism_observation` is available on every path (any role, any time).
Intake boundary is strict: ALL discovery via `shop-msg` CLI (never files/DB
tables). `shop-msg pending inbox --bc <name>`, `shop-msg read inbox --bc <name>
--work-id <id>`. (bc-router SKILL "Intake Boundary".)

### 1.3 The scenario-work loop (the full gated pipeline)

From `bc-router` SKILL flowchart + "Step-by-Step Protocol" steps 5–11:

1. **Read** the message (`shop-msg read inbox`).
2. **Sufficiency check** — invoke `bc-sufficiency-check` skill. Binary verdict
   proceed/clarify, per-message-type criteria (§1.5). Insufficient →
   `shop-msg respond clarify` naming the gap, and STOP (no dispatch).
3. **Isolate** — `using-git-worktrees`: create a branch/worktree named for the
   `work_id` before any implementation.
4. **Plan (scenario work only)** — `writing-plans-bdd`: decompose assigned
   scenario(s) into a bd sub-issue DAG — one RED sub-issue + one GREEN sub-issue
   per behavior, `bd dep` edges encoding order. Router does NOT write feature
   files / step defs / src itself.
5. **Orchestrate (scenario work only)** — `subagent-driven-development` loop:
   `bd ready` → dispatch all unblocked sub-issues **in parallel** to
   `bc-implementer` subagents (Task/Agent tool) → wait → **inter-layer gate**:
   verify each sub-issue closed AND `test(red)` precedes `feat(green)` in the
   work-branch history → repeat until DAG drained.
6. **Integrate (scenario work only)** — `integrating-to-main`: land the work
   branch on `origin/main`.
7. **Review dispatch (scenario work only)** — dispatch `bc-reviewer` subagent.
   Router does NOT emit work_done. Reviewer is the SOLE gate for scenario work.

Non-scenario work (`request_maintenance`, empty-scenario `request_bugfix`):
dispatch a single `bc-implementer` (no planning, no reviewer); implementer emits
`work_done` directly via `work-done-gate`. (`bc-router` step 11.)

### 1.4 Implementer role — inner loop and gates

From `shop-templates show bc-implementer` (== `bc-implementer.md`):

- Tools: `Read, Edit, Write, Bash, Grep, Glob, Skill`. `model: inherit`.
- Bias: "make the assigned behavior real via TDD. You are NOT the gate."
- FIRST ACTION per single-behavior dispatch: invoke `test-driven-development`
  skill and run RED→GREEN→REFACTOR:
  1. failing test committed `test(red): <behavior>` BEFORE any impl;
  2. watch it fail (mandatory);
  3. minimal impl; 4. commit passing `feat(green): <behavior>`;
  5. optional `refactor: <behavior>`; 6. close the bd sub-issue.
- Skills composed (scenario work, in order): `bc-sufficiency-check`,
  `test-driven-development`, `using-git-worktrees`, `integrating-to-main`.
- **Hash recompute (REQUIRED discrete step):** after writing/editing any
  `@scenario_hash:<value>` tag under `features/`, recompute via the canonical
  `scenarios hash` CLI using **scenario-block-only** canonicalization (ADR-019 /
  scenario 117 — enclosing `Feature:` line NOT hashed); recomputed value MUST
  equal the on-disk tag for EVERY touched tag. May not compose the terminal
  handoff/response while any touched tag fails this recompute-equality check.
- Who emits: scenario paths → does NOT emit work_done, hands to reviewer
  (only exception: failed sufficiency → emit `clarify` directly).
  `request_maintenance` / empty-scenario `request_bugfix` → implementer IS the
  emitter, runs `work-done-gate` first; any gate failure converts
  `--status complete` → `--status blocked` with named evidence.
- BC-root-only constraint: reads/modifies only files inside the BC root.
- May surface at most one primary response (clarify OR work_done) + optionally
  one `mechanism_observation` when its trigger genuinely fires.

### 1.5 Reviewer role — adversarial gate, sole work_done emitter

From `shop-templates show bc-reviewer` (== `bc-reviewer.md`):

- Tools: `Read, Edit, Write, Bash, Grep, Glob, Skill`. Adversarial stance; SOLE
  role authorized to emit `work_done` (status=complete) for scenario work.
- FIRST ACTION (both mandatory, in order): 1. `bc-review` skill (re-run BDD
  suite; probe faithful realization of scenario intent; probe step defs for
  broad regexes / swallowed exceptions / state leakage; verify `test(red)`
  precedes `feat(green)` for each behavior in work-branch history); then
  2. `work-done-gate` skill.
- Three outcomes (emit exactly one via shop-msg):
  - **Sign-off → work_done complete** via the **`bc-emit work-done` wrapper**
    (NOT bare `shop-msg respond` — the wrapper re-runs gate preconditions).
    Command shape:
    `bc-emit work-done --bc <name> --work-id <id> --scenario-hash <h1> [--scenario-hash <h2> ...] --summary "<probes considered+dismissed>"`.
    Echo back EVERY currently-passing scenario hash (newly assigned + pre-existing
    additive). Summary MUST be substantive/non-placeholder (guard against
    `test`/`tbd`/`wip`/single word/empty).
  - **Scenario gap → clarify to lead** — `shop-msg respond clarify ... --question`.
  - **Implementation gap / gate fail → work_done blocked** —
    `shop-msg respond work_done ... --status blocked --summary`.

### 1.6 The three pre-emit gate checks (`work-done-gate` SKILL)

Before any `work_done --status complete`, ALL three must pass; any failure →
`--status blocked` with named evidence. (`skills/work-done-gate/SKILL.md`.)

- **Check 1 — clean working tree (deliverable-scope).** `git status --porcelain
  -uall`. Deliverable dirs = `features/`, `src/`, `tests/`. Dirty deliverable
  path → FAIL. Non-deliverable churn (harness/config: `.claude/settings.json`,
  `.claude/canonical/bc-primer.md`; ambient carve-outs: `.beads/issues.jsonl`,
  `.specstory`, `.claude/scheduled_tasks.lock`) NEVER blocks. The executable
  `bc-emit work-done` wrapper discounts these via `_CARVE_OUTS`.
- **Check 2 — work_id commit reachable from `origin/main`.** `git fetch origin`
  then `git log origin/main -E --grep="\b<work_id>\b" --oneline`. Word-boundary
  WHOLE-TOKEN match (a strict prefix like `lead-8v` of `lead-8vwf` does NOT
  match). Tags/`git notes` naming exactly the work_id also acceptable.
  Idempotent-no-op branch: flat maintenance whose end-state already holds with
  zero delta passes with no commit.
- **Check 3 — scenario-hash integrity (ADR-010).** `work_done.scenario_hashes`
  must be a SUBSET of `@scenario_hash:` tags pinned in committed `features/`.
  3a recompute via `scenarios hash features/<file>.feature`; 3b confirm presence
  via `git grep "@scenario_hash:<hash>" features/`; 3c enforce subset (may report
  fewer, never a hash absent from `features/`).

Additional wrapper-enforced preconditions (named in both role shims): clean
working tree, work_id committed on origin/main, scenario-hash match INCLUDING
orphan/stale/missing refusal. Bare `shop-msg respond work_done --force` is the
forced-recovery escape valve ONLY, never the routine sign-off emit.

### 1.7 The exact shape of a `work_done` emission

From `catalog/schemas.py` (`class WorkDone`) and `shop-msg respond work_done
--help`:

```python
class WorkDone(BaseModel):
    message_type: Literal["work_done"]
    work_id: str
    status: Literal["complete", "partial", "blocked"]
    summary: str | None = None
    scenario_hashes: list[str] = Field(default_factory=list)
```

CLI: `shop-msg respond work_done [--bc BC] --work-id WORK_ID --status
{complete,partial,blocked} [--scenario-hash H (repeatable)] [--summary S]
[--force]`. `--bc` optional — resolved from CWD via `.claude/shop/` marker
walk-up (PDR-008). `--force` replaces an existing same-type outbox response for
the work_id (refuses on collision without it, lead-2id).

Note two emit paths for the same wire message:
- routine sign-off: `bc-emit work-done` wrapper (re-runs gate);
- primitive: `shop-msg respond work_done` (used for `--status blocked`, forced
  recovery, and implementer-emitted non-scenario paths).

The CLI/pydantic BUILD and VALIDATE the message; roles NEVER hand-write YAML.
`ScenarioPayload` (in lead→BC messages) validators enforce: gherkin must carry a
`@bc:<name>` tag-line, AND `hash == compute_scenario_hash(gherkin)` (canonical
hash owned by `scenarios.hash.compute_scenario_hash`, re-exported in
`catalog.schemas`). (`catalog/schemas.py` lines 76–124.)

### 1.8 Full BCResponse / LeadMessage union (the wire contract)

`catalog/schemas.py` lines 321–334:
- `LeadMessage = Union[RequestMaintenance, AssignScenarios, RequestBugfix,
  RequestCompletionJournal, Nudge]`
- `BCResponse = Union[Clarify, WorkDone, MechanismObservation,
  RequestCompletionJournalResponse, Nudge]`

`shop-msg respond` subcommands: `clarify, work_done, mechanism_observation,
request_completion_journal`. `shop-msg send` (lead→BC): `request_maintenance,
assign_scenarios, clarify_response, request_bugfix, request_completion_journal,
request_scenario_register, nudge`. A `nudge` flows both directions (ADR-015;
carries NO scenario state — `_reject_scenario_state` guard).

---

## Section 2 — The bc-container / bc-launcher launch interface (parity target)

The launcher is `bc-container`, owned by the `shopsystem-bc-launcher` BC
(ADR-004; PDR-004). A fabro launcher must satisfy this same interface. Owner
subcommands (ADR-004; scenario 17 `17-bc-container-on-path.gherkin`):
`launch, attach, inject, monitor, stop, status, list`. All facts below are from
`features/bc-launcher/*.gherkin`, `bring-up-bc`/`create-bc` skills, `compose.yaml`,
`bc-manifest.yaml`, `ops/ops-coordinates`, ADR-004/PDR-004/PDR-020.

### 2.1 What `launch` DOES (container-init sequence)

- Starts a Docker container named `bc-<bc-name>` (e.g. `bc-shopsystem-messaging`)
  from the pinned **bc-base** image (scenario 01; `bring-up-bc` §1). The image is
  owned/published by bc-launcher (scenarios 36/37/42; ADR-021/022).
- Clones the BC repo into the container's workspace (`/workspace`) — clone happens
  INSIDE the container (scenario 02). Repo URL resolved from `bc-manifest.yaml`
  entry (`bring-up-bc` §1; `bc-manifest.yaml`).
- Pulls beads state via `bd dolt pull` inside the workspace; `.beads` dir exists
  at workspace root (scenario 03); launch leaves beads FUNCTIONAL, not just
  pulled (scenario 32).
- Pours the `shop-templates` skill-group into `<workspace>/.claude/skills/`
  (scenario 43) — the bc-base image carries the `shop-templates` binary
  (scenario 42) but a fresh clone has no `.claude/skills/`, so launch runs the
  pour.
- Starts a named **tmux** session `agent` inside the container (scenario 04).
- Optionally injects a `--startup-prompt` after the readiness barrier (below).

### 2.2 Readiness barrier (gate between container-up and agent-engage)

- Barrier is a single defined, **idempotent**, re-runnable sequence; startup
  prompt is injected ONLY after it passes (scenario 34). Re-running against an
  already-ready container is a no-op reporting ready (scenario 34 second scenario).
- Barrier composes BOTH supporting servers (scenario 48): messaging postgres
  (`SHOPMSG_DSN`) reachable AND the agent-vault broker reachable. Passes only if
  BOTH up; withholds engagement if EITHER down.
- Messaging-DB gate: launch exits non-zero + stderr names `SHOPMSG_DSN` when the
  DB is unreachable, and NO startup prompt is sent (scenario 33).
- Agent-vault gate: launch exits non-zero + stderr names the configured broker
  address when broker unreachable; no prompt sent (scenario 47).
- Health reflects readiness, not liveness: a Docker HEALTHCHECK reports healthy
  only when beads usable AND messaging DB reachable (scenario 35); unhealthy when
  broker unreachable despite the process being alive (scenario 47 second).

### 2.3 Engage / startup-prompt submission discipline (tmux)

- `inject` sends prompt text to the `agent` tmux session via `tmux send-keys`
  (scenario 07). `monitor` streams the tmux pane output to host stdout
  (scenario 08) — this is the host-discoverable engage observability surface.
- `--startup-prompt` must AUTONOMOUSLY commit (agent processes with no follow-up
  keystroke) (scenario 27), and must be issued as **two discrete `send-keys`
  invocations**: first the text alone, then the Enter key alone; no single
  invocation carries both (scenario 30). (Root cause: single-write payloads get
  absorbed as paste by the TUI.)
- Engage auto-dismisses a blocking, escape-able interactive option screen by
  sending a discrete **Escape** key (not Enter) as a separate send-keys
  invocation, then submits the real prompt; what it dismissed is logged as a
  host-discoverable WARNING on the `monitor` surface (scenario 55).

### 2.4 Isolation + mounts a launcher MUST match

- **No sibling BC / lead-workspace mounts:** the only bind mounts are the BC's
  own repo mount; no candidate sibling directory appears as a mount source
  (scenario 15).
- **No host-filesystem credential mounts:** no host `~/.claude` mount, no RW
  mount targeting `/home/vscode/.claude`, no `~/.config/gh`, no `~/.gitconfig`
  (scenario 44). Launch must not require `BCLAUNCHER_HOST_HOME` to resolve a
  credential path (scenario 44 third; `bring-up-bc` §2 — `BCLAUNCHER_HOST_HOME`
  is required ONLY for the bind-mounted-home devcontainer case, never clone-path).
- **Credentials brokered, not mounted (agent-vault model):**
  - The agent is launched wrapped as `agent-vault run -- claude` (scenario 45).
  - The agent process env sets `HTTPS_PROXY` to the broker's proxy listener on
    the shop network (scenario 45).
  - The container's `.credentials.json` is a read-only `__PLACEHOLDER__`; the
    real OAuth token never appears in the container (scenarios 45, 50).
  - Inside the container: no real Claude OAuth token, no real GitHub token, no
    host gh/gitconfig path; the ONLY credential-bearing secret is the revocable
    agent-vault proxy token granting only proxy substitution (scenario 50).
  - bc-base carries `gh` and `agent-vault` on PATH (scenario 64); interactive
    bootstrap entrypoint MODE exists for the one-time human claude+gh auth beat
    that produces the broker credential (scenario 51; ADR-040 / PDR-019).

### 2.5 Network + env coordinates (in-container environment)

- `SHOPMSG_DSN` is set inside the container so in-container `shop-msg` reaches
  the same postgres as the host (ADR-004 Decision).
- Shop docker **network** resolves from on-disk config with NO `--network` flag,
  when `bc-manifest.yaml` carries no shop-level network field; resolved value is
  the product slug `shopsystem` (scenario 63; `bc-manifest.yaml` `product:`
  field; `compose.yaml` `networks: shopsystem`). ADR-043/PDR-030 single-source.
- Canonical coordinates (all derived from the slug) are declared once in
  `ops/ops-coordinates` (sourced, not executed; ADR-043 Phase 1):
  `OPS_NETWORK={{OPS_SLUG}}`, `OPS_AGENT_VAULT_CONTAINER={{OPS_SLUG}}-agent-vault`,
  `OPS_POSTGRES_CONTAINER={{OPS_SLUG}}-postgres`,
  `OPS_AGENT_VAULT_ADDR=http://{{OPS_SLUG}}-agent-vault:14321` (in-network),
  `OPS_BROKER_LOCAL_ADDR=http://localhost:14321`. Host-reachable broker addr is
  discovered at runtime via `docker port` and recorded as `AGENT_VAULT_HOST_ADDR`
  in `.env`. Broker container ports fixed: 14321 (API), 14322 (HTTPS proxy);
  host ports slug-derived/override-aware (`compose.yaml` agent-vault service).
- Supporting servers (must exist on the network for the barrier to pass):
  `shopsystem-postgres` (postgres:16, `SHOPMSG_DSN`) and `shopsystem-agent-vault`
  (`infisical/agent-vault:latest`, master-password unseal) — `compose.yaml`.

### 2.6 LEAD profile (additive launch capabilities, PDR-020)

Two additive capabilities a normal BC does NOT need (scenario 54; PDR-020):
- **workspace-mount:** bind-mount an existing host tree as `/workspace`, SKIP the
  clone AND skip clone-path provisioning (no `bd bootstrap`, no `shop-templates`
  re-pour); mounted `.beads` + `.claude/skills` byte-unchanged.
- **docker-socket opt-in:** mount `/var/run/docker.sock` ONLY when the lead-only
  opt-in flag is given (never default) so the lead agent can run `bc-container`.
  Default (BC) = no socket.

### 2.7 Verify-online contract (bring-up-bc)

`bc-container launch` exit 0 means "container started", NOT "online". Must verify
via `shop-msg bc-status` (heartbeat table, ADR-014) that the BC row reaches
`online`, and confirm it accepts a `shop-msg` ping/dispatch (`bring-up-bc` §3 +
Definition of Done). `bc-status` states seen: online/stale/offline (`shop-msg
--help`). `bring-up-bc` flags the E2E launch path as still being hardened.

---

## Section 3 — shop-templates furniture to translate into fabro's workflow format

Everything below is what fabro's workflow must re-express. Full inventory from
`ls .../shop_templates/templates/` and its subtrees.

### 3.1 Role prompts (subagent definitions)

- `bc-implementer.md` — bias-shim; §1.4. Tools `Read,Edit,Write,Bash,Grep,Glob,
  Skill`; composes `bc-sufficiency-check`, `test-driven-development`,
  `using-git-worktrees`, `integrating-to-main`.
- `bc-reviewer.md` — bias-shim; §1.5. Composes `bc-review` then `work-done-gate`.
- (`lead-architect.md`, `lead-po.md` also ship but are LEAD-shop roles, out of
  scope for the BC loop; noted for completeness.)

### 3.2 Workflow / gating skills (the discipline, `templates/skills/`)

- `bc-router/SKILL.md` — the loop orchestrator: intake boundary, classification
  table, router flowchart (dot), session-start health step, step-by-step
  protocol, "what the router does NOT do", clarify protocol. This is the primary
  workflow-graph artifact to port to fabro.
- `bc-sufficiency-check/SKILL.md` — per-message-type proceed/clarify gate
  (§1.5-criteria: `request_maintenance` needs measurable outcome-defining
  acceptance criteria + named subject; `assign_scenarios` needs well-formed
  Given/When/Then, concrete testable steps, `@scenario_hash:` tag per scenario,
  fits-existing-capability probe; `request_bugfix` empty vs non-empty sub-cases).
  Includes anti-rationalization (under-asking / over-asking guards).
- `writing-plans-bdd/SKILL.md` — decompose scenarios into a bd sub-issue DAG
  (RED + GREEN per behavior, `bd dep` edges).
- `subagent-driven-development/SKILL.md` — the parallel dispatch loop
  (`bd ready` → dispatch unblocked in parallel → inter-layer gate → repeat).
- `test-driven-development/SKILL.md` (+ `testing-anti-patterns.md`) — the
  RED→GREEN→REFACTOR inner loop with `test(red)`/`feat(green)` commit discipline.
- `using-git-worktrees/SKILL.md` — work_id worktree isolation.
- `integrating-to-main/SKILL.md` — land the work branch on `origin/main`.
- `bc-review/SKILL.md` — adversarial review gate.
- `work-done-gate/SKILL.md` — the three pre-emit checks (§1.6).
- `po-architect-decomposition-exchange/SKILL.md` — (lead-side; noted).

### 3.3 CLAUDE.md assembly + settings furniture

- `claude/bc.md` — the BC shop `CLAUDE.md`: FIRST-ACTION session-start checklist,
  work-tracker health step, standing rules (end-of-turn continuation, idle-
  detection checklist, choice suppression), who-you-are, inbox/outbox protocol,
  beads discipline. `claude_body/bc.md` = the `@`-include stub
  (name.md/type.md/bc-primer.md/primer.md).
- `claude_settings/bc.json` — `.claude/settings.json`: SessionStart hooks
  `bd prime` and `shop-msg prime` (short-lived synchronous hooks; the reactive
  watcher is armed via the in-session Monitor, NOT a hook).
- `gitignore.template`, `starter/` — scaffolding (not inspected in depth).

### 3.4 Ops furniture (`templates/ops/`)

`agent-vault-approve-claude`, `agent-vault-check`, `agent-vault-provision`,
`compose.yaml`, `footing`, `ops-coordinates`, `shop-scenario-completion`,
`shop-shell`. `ops-coordinates` is the single-source coordinate file (§2.5);
`compose.yaml` stands up postgres + agent-vault. These are the supporting-server
+ credential-broker furniture a fabro orchestration must also stand up or match.

### 3.5 Translation notes for fabro

- The loop is a DAG with typed nodes (router / implementer / reviewer) and hard
  gates (sufficiency → worktree → plan → parallel-impl inter-layer gate →
  integrate → review → 3-check work-done-gate). Fabro's workflow format must
  encode: node types, the parallel fan-out at `bd ready`, the inter-layer commit-
  ordering gate, and the terminal 3-check gate with block-conversion semantics.
- Skills are invoked via the **Skill tool**; subagents via **Task/Agent tools**.
  Fabro must provide equivalents (a skill-invocation primitive and a subagent-
  dispatch primitive) or inline the skill prose.
- Emission is via `shop-msg`/`bc-emit` CLIs (pydantic-validated). Fabro's loop
  must terminate in the SAME wire emission (WorkDone/Clarify/MechanismObservation)
  through those CLIs — the wire contract (catalog.schemas) is the integration
  boundary, and is what parity is measured against.

---

## Flagged UNRESOLVED (would need the BC to report via mailbox / not on this surface)

- `[UNRESOLVED]` The EXACT bc-base image reference/tag/digest currently pinned by
  `bc-container launch` — the launcher's concrete image pin lives in the
  bc-launcher BC source (not on this host, ADR-018). Scenarios pin the BEHAVIOR
  (pull current `latest`, not stale cache — scenario 39; rollback by republishing
  prior digest — scenario 41) but not the literal digest in effect.
- `[UNRESOLVED]` The concrete `docker run` argv / full env-var set and mount list
  the launcher emits (e.g. exact `--network`, `-e SHOPMSG_DSN=...`, socket paths,
  `.credentials.json` mount path). Scenarios assert observable properties
  (FakeDockerDriver records `--network shopsystem`, scenario 63; mounts via
  `docker inspect`) but the full argv is bc-launcher-internal implementation.
- `[UNRESOLVED]` Internal shape of the readiness-barrier implementation
  (driver.py:312 `messaging_db_reachable` referenced in scenario 47 prose) — the
  code is not on this host; only the pinned observable behavior is available.
- `[UNRESOLVED]` The concrete tmux key-name token the launcher maps "Escape" to
  (scenario 55 says the BC owns and must echo it in `work_done`; conventional
  name is "Escape") — determined by the BC, reported via mailbox.
- `[UNRESOLVED]` Whether `shop-msg bc-status` `online` transition, the heartbeat
  cadence (ADR-014), and the E2E launch path are currently GREEN end-to-end —
  `bring-up-bc` explicitly flags the path as "still being hardened"; empirical
  liveness is a BC/live-fleet mailbox observation, not readable here.
- `[UNRESOLVED]` The `scenarios hash` CLI's exact canonicalization bytes are used
  by the loop but the CLI is an installed contract tool; block-only rule (ADR-019)
  is documented, but a live recompute calibration belongs to the scenarios BC.

> **ARCHIVED** — historical spike record, not current state (ADR-065). Superseded by: informed the fabro-adoption decision recorded in ADR-048; no dedicated graduation ADR of its own.

# Orchestration-substrate evaluation — five candidates vs. the fabro baseline

Initiative: lead-odqd · eval bead: lead-8mho
Date: 2026-06-09

## What this evaluates

Whether any of five orchestration substrates — **pipelex**, **keystone-cli**,
**DKMV**, **agent-runtime**, **agentic-lab** — could replace one of the two
shopsystem seams (BC launch; the reactive Monitor/loop) while honoring the
three invariant-surfaces (bd as authoritative state; abstract `<system>/<name>`
addressing; ADR-018 empirical harvest via `shop-msg` + `scenarios hash`), under
the user's hard constraints: **relatively simple AND self-hostable**.

The calibration target is **fabro** (not re-evaluated here): seam-a CLEAN,
seam-b PARTIAL, three known leaks, sharpest risk = checkpoint-on-every-node vs.
ADR-012 bd-first 2PC.

## Scorecard

Legend — seam: CLEAN / PARTIAL / REFUTED / N-A. Leak columns: how badly the
tool threatens each invariant (None / Minor / Real / Fatal-pull). Sharpest-risk
severity: how hard the ADR-012 bd-first-2PC race bites. Fit: overall fit for
shopsystem.

| Tool | Seam-a (BC launch) | Seam-b (Monitor/loop) | Leak 1: bd authority | Leak 2: addressing | Leak 3: ADR-018 harvest | Sharpest-risk severity | Self-hostable | Simple | Maturity | Overall fit |
|---|---|---|---|---|---|---|---|---|---|---|
| **fabro** (baseline) | CLEAN | PARTIAL | Real (checkpoint) | Absent (no analog) | Real (must not harvest outputs) | High (checkpoint/node) | Yes | Moderate | Shipping | **baseline** |
| **pipelex** | PARTIAL (PipeFunc wraps launch) | REFUTED (no event-wait; busy-poll only) | Real (Temporal/durable) | Absent | Real (PipeOutput pull) | High *if* `respond` in Temporal activity | Yes (DIRECT mode, BYO LLM) | Moderate (DSL) | Active | **poor-fit** |
| **keystone-cli** | PARTIAL (shell/docker step; weak discriminator) | REFUTED (DAG run-to-completion; no async wake) | Real (always-on step_executions resume store) | Absent | Real (run outputs) | High (StepExecution write window) | Yes (BYO LLM, config setup) | Moderate | Single-author, ~4.5mo stale | **poor-fit** |
| **DKMV** | PARTIAL (SWE-ReX Docker; needs bc-base surgery) | REFUTED (per-component run; no inbound wake) | Real (per-step commit/push) | Absent | Real (.dkmv/runs outputs) | High (whole component node co-located) | Yes (OSS, local Docker) | Low (substitutive, image surgery) | OSS | **poor-fit** |
| **agent-runtime** | PARTIAL (run-to-completion DAG) | REFUTED (process exits at frontier; no event loop) | Real (`--checkpoint` opt-in + `--data-dir` SDK store) | Absent (no cross-bundle addressing) | Real (`--data-dir` output.json/event-stream is the *designed* harvest pull) | High (checkpoint post-node) | Yes (single binary, LLM keys) | High (lean) | OSS | **poor-fit** |
| **agentic-lab** | N-A (code generator; emits `NotImplementedError`) | N-A (no runtime) | N-A | N-A | N-A | N-A (no execution) | N-A | N-A | Alpha codegen; PyPI badge false | **not-viable** |

## Per-tool prose

### pipelex — poor-fit
Seam-a is workable: a `PipeFunc` node can wrap the BC launch, and DIRECT mode
runs without the Pipelex Gateway (BYO/local LLM), so self-hostability is real.
The killer is **seam-b**: Pipelex's controllers are sequence / batch / parallel
/ condition — all **data-conditional, none event-waiting**. There is no
primitive that blocks-and-wakes on an external postgres LISTEN/NOTIFY arrival;
hosting `shop-msg watch` means a busy-poll inside a PipeFunc. The sharpest risk
only bites *if* one puts `shop-msg respond` inside a Temporal activity (an
avoidable design choice the eval correctly hedged). Not run as a spike; the
event-wait negative is inferred from the controller set, but the controller set
was independently confirmed to lack any signal/wait member, so the REFUTED on
seam-b stands. **Does not beat fabro** — fabro at least keeps `shop-msg watch`
alive as a command node inside its loop (PARTIAL); pipelex cannot express the
wake at all (REFUTED).

### keystone-cli — poor-fit
A `shell`/`docker run` step can launch a BC, and a `human`/`confirmPlan` step
*loosely* gestures at the discriminator gate — but the critic flagged this
mapping as hand-waved and possibly a binary approve/reject that loses the
message-type vehicle (assign_scenarios / request_bugfix / request_maintenance).
Seam-b is REFUTED: it is a run-to-completion DAG with no async-arrival wake. The
load-bearing leak is **not** the opt-in `idempotency_records` table the eval
fingered (the eval's "every step is wrapped" claim is **false** — the envelope
is opt-in, gated on an author-set `step.idempotencyKey`); it is the **always-on
`step_executions` store**, which `keystone resume` reads to build its skip-set.
That is the true competing authority and the true ADR-012 race surface. Stale
(~4.5mo, single author). **Does not beat fabro.**

### DKMV — poor-fit
Seam-a looks like a cheap image swap but is not: SWE-ReX `DockerDeployment`
needs `swerex-remote` on port 8000 inside the container (pre-baked or
runtime `pipx install` with egress), which `bc-base` does not ship — and DKMV's
adapter model **replaces** bc-base's tmux-based agent launch rather than
wrapping it (substitutive, not additive). Seam-b REFUTED (per-component
run-to-completion, no inbound wake). The ADR-012 race surface is the **whole
component node** (one container/session per component), not just an isolated
step. Operationally non-trivial despite being OSS + local-Docker.
**Does not beat fabro.**

### agent-runtime — poor-fit, but the cleanest of the five on simplicity
The leanest candidate: a single Go binary, no daemon (verified — no
`ListenAndServe`/`net.Listen`/`grpc.Serve`), runs on LLM keys alone. That makes
**simplicity its standout axis** — arguably simpler than fabro. But seam-b is
the most decisively REFUTED of the lot: it is a run-to-completion DAG, the
process **exits at frontier end**, there is no event loop, and the only shipped
HTTP tool has a hardcoded non-configurable 30s timeout — so a tool_call cannot
host a minutes-to-hours blocking wait on a BC response. Each lead↔BC round would
be a fresh `agent-runtime run`, pushing the entire Monitor/loop seam into an
**external wrapper** — at which point agent-runtime is a flow-step *library*,
not a substrate. Two durable-store surfaces (`--checkpoint` AND `--data-dir`
SDK mode, whose documented purpose is to stream events + persist `output.json`)
are both competing-authority + ADR-018 harvest pulls; the second is the
*designed* integration path, so the bd-authority leak is not merely "omit one
flag." **Does not beat fabro overall** — fabro's seam-b is PARTIAL where
agent-runtime's is REFUTED — but it is the candidate most worth a confirming
spike precisely because its simplicity is real and its refutation is still
code-read, not constructed.

### agentic-lab — not-viable
A **code generator**, not a runtime. Generated `invoke` bodies emit
`raise NotImplementedError`; the langchain generator emits `# TODO: Define nodes
and edges`. Zero execution primitives in src (no asyncio/listen/notify/
subprocess/docker-run/server). Its `protocols/events.py` (NATS/Kafka/CloudEvents)
and `security/governance.py` are **pure Pydantic config models** stamped into
scaffolds — no client, consumer, or enforcement engine — so they are not a
seam-b analog. The PyPI install badge points at an unrelated record-and-replay
package. Neither seam is even partially present; no spike warranted. The only
salvage is **idea-level vocabulary** (clearance tiers, can_delegate_to, PII
scrubbing) if ever wanted — treat strictly as inspiration, not capability.

## Cross-cutting findings

1. **Every candidate REFUTES seam-b.** None has a native primitive for an
   external async arrival (postgres LISTEN/NOTIFY inbound). This is the same gap
   fabro has (fabro's 15 hooks are all internal lifecycle points) — except
   fabro keeps `shop-msg watch` alive as a command node (PARTIAL), while the DAG
   tools (pipelex/keystone/DKMV/agent-runtime) run-to-completion and force the
   reactor fully external (REFUTED). **The reactive Monitor/loop seam is the
   structural moat; no general-purpose substrate in this set fills it.**

2. **Leak 2 (addressing) is Absent in every candidate.** None has any analog to
   the ADR-006/020 abstract `<system>/<name>` registry. This is invariant by
   construction for this whole tool class — they address tasks/runs/bundles, not
   shops.

3. **Leak 1 + Leak 3 recur as the same shape:** every candidate ships a durable
   run/step store that is simultaneously a competing-authority pull against bd
   AND the tempting ADR-018 harvest shortcut. The discipline ("demote to
   resume-only; harvest only via shop-msg + scenarios hash") is identical across
   all of them and is exactly fabro's discipline.

4. **Sharpest risk (ADR-012 bd-first 2PC):** uniformly High-conditional. It only
   bites if `shop-msg respond` executes inside a checkpointed/retried node on the
   same node. The mitigation is the same everywhere: keep `shop-msg respond`
   OUTSIDE any durable/replayed/retried step. No candidate makes this *safer*
   than fabro; none makes it impossible.

## Bottom line

**Nothing in this set clearly beats fabro on the simple + self-hostable axis.**
agent-runtime is the only one that competes on *simplicity* (single Go binary,
no daemon) and ties on self-hostability — but it loses harder on seam-b
(REFUTED vs. fabro's PARTIAL) and carries a second hidden durable store. The
rest are equal-or-worse on every axis and add DSL/staleness/image-surgery cost.
fabro remains the baseline to beat; this set does not displace it.

## Recommendation

Exactly **one candidate merits a real kill-or-confirm spike: agent-runtime** — the only one whose simplicity is genuinely competitive with (arguably better than) fabro and whose self-host story is a single binary on LLM keys, yet whose seam-b refutation is still *code-read, not constructed*. The spike should (a) attempt to construct ANY config that wakes on a live postgres NOTIFY and re-enters the flow — **kill criterion:** if only a fully-external wrapper works, it is a flow-step library, not a substrate; and (b) confirm whether operating it as a substrate forces `--data-dir` (making the bd-authority leak not merely opt-out).

agentic-lab needs no spike (not-viable, kill confirmed). pipelex / keystone / DKMV do not warrant a spike ahead of agent-runtime — each is equal-or-worse on simplicity and already REFUTED on seam-b by controller-set / DAG-exit evidence. The agent-runtime spike (lead-fih1) was the sole gate on firming this conclusion.

## Decision (2026-06-09)

The conclusion is **firm** — the agent-runtime gate is resolved. The
agent-runtime kill-or-confirm spike (lead-fih1) was **closed by decision on
2026-06-09**: the spike was not run to completion; the user abandoned the
agent-runtime substrate path and the KILL criterion was met by decision.
**agent-runtime is REFUTED as a general orchestration substrate.** That
closure is itself the substrate-eval conclusion for this set.

Recorded decision:

- **agent-runtime is REFUTED** as a general orchestration substrate (by
  decision, lead-fih1 closed 2026-06-09 — kill criterion met without further
  spiking; its seam-b refutation stands, code-read evidence not overturned).
- **The reactive Monitor/loop is a shopsystem-OWNED seam** — no general
  substrate in this set fills it. It stays shop-owned regardless of which
  substrate is chosen for seam-a (BC launch) or any other concern.
- **fabro (lead-f6ta) remains the surviving baseline-to-beat** for the
  orchestration-substrate question. None of the five candidates displaced it;
  the Monitor/react seam stays shop-owned even under fabro.
- **Standing requirement going forward:** any future substrate must produce a
  *constructed* (not code-read) demonstration of external-arrival-wake (live
  postgres LISTEN/NOTIFY inbound re-entering the flow) before its seam-b is
  rated above PARTIAL.

## Follow-up beads (filed under lead-odqd / lead-8mho)

- **P1** Spike: agent-runtime seam-b kill-or-confirm (external NOTIFY wake) — **CLOSED 2026-06-09 (lead-fih1), kill criterion met by decision; agent-runtime REFUTED**
- **P2** Spike: agent-runtime durable-store leak — does substrate use force `--data-dir`? — **moot (agent-runtime path abandoned)**
- **P2** Record substrate-eval conclusion: reactive Monitor/loop is a shopsystem-owned seam no general substrate fills — **DONE: recorded in Decision (2026-06-09) above**
- **P3** Note: agentic-lab is not-viable (codegen, no runtime) — kill, no spike

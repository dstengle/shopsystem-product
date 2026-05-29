# PDR-010 — bd is authoritative for system state; shop-msg is transport + wakeup + liveness

**Status:** draft (2026-05-29)
**Authors:** dstengle, Claude
**Anchored to:** PO intent expressed in conversation 2026-05-29:
*"What if we simply have shop-msg write to beads and nudge the agent with
the message?"* and *"I want the lead to track the desired state of the
system and be able to resolve the actual state."*

## Point of intent

The lead shop currently runs **two state stores in lockstep by
convention**: bd (beads, file-backed via dolt, survives runtime resets)
for work tracking, and shop-msg (postgres-backed) for transmission.
Agents keep both in sync — `bd update --claim` mirrors `shop-msg send`,
`bd close` mirrors `shop-msg consume`. Session start requires both `bd
prime` and `shop-msg pending {inbox,outbox}` before the router can
accept user work.

This lockstep is **maintained by convention, not by structure**. When an
agent forgets a `bd close` after `shop-msg consume`, the bead drifts
silently. When a context window resets, the lead's *strategic* state —
"BC X is waiting on Y, parked pending Z" — vanishes because it lived in
agent working memory, not in any queryable artifact.

The cost is no longer theoretical. Three failure classes recur:

- **Class A — BC stalled mid-pipeline.** Implementer finished; reviewer
  never fired. Cure: carrier pattern.
- **Class B — BC has no agent running at all.** Container down. Carrier
  doesn't help.
- **Class C — Cross-BC sequencing with the lead as implicit coordinator.**
  State held in lead-agent memory; lost across `/compact`.

The shared root cause: **the lead's strategic state is not durable**. The
decision this PDR commits is to make bd the system's source of truth for
state, and reduce shop-msg to **transport + wakeup + liveness**. bd is
more durable (file-backed, git-syncable, survives postgres outages and
runtime resets); messaging is volatile and was never meant to carry
strategic intent.

## Diagnosis

The 2026-05-29 conversation produced three concrete pieces of evidence,
one per failure class:

- **Class B — lead-ji28 / shopsystem-scenarios outage tonight.** Container
  down; no agent to drain inbox; lead had no way to know short of polling.
  A carrier on the next dispatch would do nothing — no listener at all.
- **Class A — lead-2ca / lead-xscs carrier chain.** Implementer finished,
  reviewer never woke; carrier on the next outbound cured it, but required
  the lead to *notice* the stall and *remember* to carrier. Neither is
  structural.
- **Class C — post-compact lead-ji28 messaging-side hold-and-forget.**
  After a context compact the lead resumed without recalling a
  messaging-side change held pending a scenarios-side decision. Bead was
  open in bd; the *dependency intent* was nowhere on disk.

In every case the artifact missing was the same: a queryable
representation of **what the lead intends the system to be doing**.
shop-msg knows what was sent and received; bd knows local work items;
nothing knows the cross-BC strategic picture except the lead agent's
volatile context.

## Decision

The lead shop COMMITS the following at the product / architectural-intent
level. Each numbered commit is operationalized by one or more of the
ADRs cross-referenced below.

1. **bd is the authoritative store for work-item state, priorities,
   dependencies, and judgments.** Status transitions, claim/release,
   priority changes, dependency edges, free-form notes — all live in bd.
   When a question is "what is the lead's intent for this work?", bd is
   the answer.

2. **shop-msg is the authoritative store for transmission facts AND
   liveness.** "Was this message sent? Received? Consumed? Is the watcher
   on the other side alive right now?" — shop-msg answers, via the
   outbox/inbox tables and via watch-as-heartbeat (ADR-014). shop-msg
   does not own intent; it owns motion and presence.

3. **When bd and shop-msg disagree, the reconciliation rule is:**
   shop-msg wins for "was the message sent / received / consumed"; bd
   wins for everything else (status, priority, dependencies, notes). The
   ADRs operationalize this — notably ADR-012's bd-first / outbox-pattern
   atomicity and the sweeper that reconciles the two when a write
   partially failed.

4. **Cross-shop visibility is loose, not federated.** Each shop's bd is
   sovereign; **the lead never pulls BC bd**. The lead infers BC state
   from two surfaces: (a) shop-msg emissions back from the BC (work_done,
   clarify, mechanism_observation, and the new `nudge` of ADR-015), and
   (b) git-level observation of BC sibling clones at `repos/<bc>/`. ADR-017
   pins the BC-side contract: when a BC drains its inbox, it creates its
   own bead, and the only cross-shop linkage is the shared `work_id`.

5. **Strategic-state introspection is a thin query layer**, not a new
   system. Queries like `bd ready --shop-system` (showing in-flight per
   BC, blocked-on-what) join lead bd against shop-msg's pending/inflight
   tables. Whether this lands as a bd plugin, a `shop-msg` subcommand,
   or a separate tool is deferred — but the underlying data lives in the
   two stores we already run, not in a third.

6. **Proactive lead behavior is enabled.** With (1)–(5) in place, the
   lead can answer "what's stalled?" without holding the answer in
   working memory: `bd ready --stale-since 2h` surfaces work items
   where the lead expected progress; `shop-msg bc-status` surfaces BCs
   whose watcher hasn't heartbeated. The intersection is a stall. The
   lead's response is `shop-msg nudge` (ADR-015) — an operational
   liveness ping distinct from clarify and mechanism_observation,
   designed to converge desired state with actual state without abusing
   the semantic-message channels.

## Implications for the messaging BC and templates BC

- **Messaging BC (`shopsystem-messaging`):** message-type catalog gains
  `nudge` (ADR-015). `shop-msg send`, `shop-msg respond`, and `shop-msg
  consume` gain bd-write hooks per ADR-012 — the outbox pattern means a
  send first writes the bead intent, then the message; the sweeper
  reconciles partial failures. `shop-msg watch` becomes the presence
  heartbeat (ADR-014); the long-running watcher IS the liveness signal,
  so no separate heartbeat process exists. `shop-msg send` honors
  dispatch dependencies declared via `bd dep add` (ADR-013).
- **Templates BC (`shopsystem-templates`):** role templates (lead-po,
  lead-architect, bc-implementer, bc-reviewer) gain prose for "consult
  bd for stalls before idling." The standing reaction to a Monitor
  `nudge` event is added to the lead-router primer. BC role templates
  gain the ADR-017 bead-creation contract.

Both BCs receive `assign_scenarios` and `request_bugfix` follow-ups
authored by the PO once this PDR is accepted; the ADRs above are the
authoritative design inputs for those scenarios.

## What this leaves open

- **Cost of the bd-first atomicity protocol (ADR-012).** Every send,
  respond, and consume gains a bd write. Throughput and latency under
  load are unvalidated. The sweeper's reconciliation interval is
  similarly open. Defer to the first few weeks of operation.
- **Precise `nudge` response standing rules (ADR-015).** A `nudge`
  arrives — what does the receiving agent do? The ADR pins the message
  shape and the wakeup semantic; the *receiving-role posture* (which
  template owns the reaction, what the reply commitment is) is left to
  the templates BC's revision.
- **BC-side bead naming convention (ADR-017).** Whether BC beads embed
  the shared `work_id` in their ID, in a field, or only as a note is
  pending; the BC retains naming sovereignty regardless.
- **`bd ready --shop-system` packaging.** Whether the cross-store query
  ships as a bd plugin, a `shop-msg` subcommand, or a new thin tool is
  deferred to follow-up after the data plumbing of (1)–(3) is in place.
## Cross-references

- **ADR-011** — Bead/message field mapping: the lead bd schema for
  projecting shop-msg state (work_id, message_type, peer BC, last
  emission).
- **ADR-012** — Outbox-pattern atomicity: bd-first writes, sweeper
  recovery for partial failures across the bd / shop-msg boundary.
- **ADR-013** — Dispatch dependencies via `bd dep add` honored by
  `shop-msg send`: send refuses while dependencies are open; dependency
  intent is durable in bd.
- **ADR-014** — Presence heartbeat collapsed into `shop-msg watch`: the
  watcher IS the liveness signal; no separate heartbeat daemon.
- **ADR-015** — `nudge` message type: operational liveness ping,
  distinct from clarify and mechanism_observation; the lead's lever for
  converging desired with actual state.
- **ADR-016** — shop-msg owns bd integration: every shop-msg CLI command
  with a bd correlate fires the bd write as a transactional side effect,
  not as a separate agent step.
- **ADR-017** — BC-side bead creation contract: BC creates its own bead
  on `shop-msg pending inbox` drain; lead never sees BC bd;
  cross-reference is the shared `work_id`.
- [[lead-o6tp]] — earlier ADR-candidate framed as "pre-emit-checks-via-CLI";
  this PDR subsumes that narrower framing under the broader bd-authoritative
  architecture.
- [[lead-ymct]] — parallel-dispatch deadlock mechanism; ADR-013's
  bd-dep-honoring `shop-msg send` is the structural fix.
- [[lead-bp3]] — "no consume-inbox CLI surface" gap; in the bd-authoritative
  model the bead is what the lead reads, so the missing CLI surface is moot.
- [§3 Lead shop](../03-lead-shop.md) — the lead's job description is
  unchanged; this PDR pins the *substrate* under it.

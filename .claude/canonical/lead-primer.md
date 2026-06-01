# {{SHOP_NAME}} — lead shop instructions

This repository is the **{{SHOP_NAME}}** lead shop. As an agent operating
in this repo, you are operating inside a **lead shop** under the shop-system
spec.

## Standing rule: end-of-turn continuation

After completing any unit of work — a dispatch, a reconciliation, a
reply to the user, a clarify response — the router MUST identify and
start the next ready action before declaring the turn done. Idle only
when no ready action exists. The reactive-only stance (waiting for the
next user prompt or Monitor event) cannot catch its own stalls; this
rule is the active counterpart to the Monitor watcher.

For this lead shop, ready actions live on these surfaces:

- **Outbox drain** — `shop-msg pending outbox --lead <name>`. Any row
  is an unprocessed BC response; dispatch the appropriate subagent per
  the standing rule below.
- **`bd ready`** — any unblocked bead in this lead's registry is ready
  work; route to PO or Architect per the role-discipline rules.
- **In-flight stale-check** — for any BC dispatch where the BC has not
  yet emitted a response within the expected window, surface the stall.
- **Reconciliation queue** — any `work_done` consumed but not yet
  reconciled (scenario register confirmed, hashes matched, follow-up
  beads filed) is ready work.

## Who you are — router for lead-po and lead-architect subagents

By default you are the **router** for this lead shop. The two judgment
roles — **PO** and **Architect** per §3 of the shop-system spec — are
dispatched as subagents. Your job is to classify each request and
delegate; do not enact the roles yourself.

The canonical role set for this shop type is:

- **lead-po** — authors or sharpens Gherkin scenarios; drafts briefs or
  PDRs; responds to BC `clarify` on scope or vocabulary.

- **lead-architect** — selects a message-type vehicle; composes
  `shop-msg send`; verifies BC pre-state empirically; responds to BC
  `clarify` on architecture; reconciles scenario registers; drafts ADRs;
  makes BC decomposition decisions.

Subagent definitions live at `.claude/agents/lead-po.md` and
`.claude/agents/lead-architect.md`. These are inline copies of the
canonical templates shipped by the `shopsystem-templates` BC; do not
edit them independently of the canonical source.

## How feature requests get handled

When a user request implies a new BC capability, a tightening, or a flat
change to an existing BC:

1. **PO authors intent first.** Brief → PDR → Gherkin scenarios.
   Implementation discussion before authored scenarios is the failure
   mode §3 exists to prevent.
2. **Architect verifies the relevant BC's pre-state empirically against
   the contract/artifact surface.** Admissible evidence is: this repo's
   `features/` Gherkin, `adr/`/`pdr/`, message schemas, scenario hashes
   computed via the installed `scenarios hash` contract tool (ADR-018 D2),
   `shop-msg` mailbox state, and the BC's reported `work_done`
   demonstration. The lead host carries no `repos/` BC source — there is
   nothing to read, run, or git-observe. Construct the demonstration
   against the artifact surface, cite it in the dispatch description. Any
   question that would otherwise require running BC implementation routes
   to the BC as a `clarify` or `nudge`, never as a lead-side execution.
3. **Architect applies the message-type discriminator:**
   - No capability → `assign_scenarios`.
   - Capability exists but unpinned → `request_bugfix`.
   - Flat (refactor / doc / value-only) → `request_maintenance`.
4. **Architect dispatches via `shop-msg send`.** Never write inbox/outbox
   YAML by hand.

## Do not

- **No implementation code in this repo.** This is the lead shop; code
  lives in BCs.
- **No skipping the discriminator.** If a request smells like open-ended
  "what should we build?" — route it back through the process. First
  question: *what scenarios pin this?*

## Beads (bd) discipline

This shop uses **bd (beads)** for its work-tracking registry. Lead-shop
bead IDs are the canonical `work_id` values that flow outward into
`shop-msg send` when dispatching to a BC.

- Run `bd prime` at the start of a working session to load the full
  workflow context and command reference for this repo.
- Use `bd ready` to find available work, `bd show <id>` to inspect
  an issue, `bd update <id> --claim` to claim work, and `bd close <id>`
  to mark work complete. Do NOT track work in markdown TODO lists or
  alternative trackers.
- Use `bd remember` for persistent knowledge that should outlive the
  session.

## Session start: arming the lead-inbox watcher via the in-session Monitor

This shop is reactive on session start: when a BC drops a response
into the lead shop's inbox, the router must learn about it without polling. The
activation mechanism is the in-session **Monitor** tool — not a
`SessionStart` hook in `.claude/settings.json`. (Earlier iterations of
this template tried the hook path; Claude Code awaits `SessionStart`
hooks synchronously, so a foreground pipeline never returns and session
startup hangs. The Monitor tool is the documented in-session primitive
that delivers the streaming-stdout-as-notifications semantic the hook
was faking, without blocking startup.)

**At session start, the router must arm the in-session Monitor tool on
`shop-msg watch --lead <name>`** — this is the postgres LISTEN/NOTIFY
watcher that delivers one notification line per new BC response arriving
in the lead shop's inbox. `shop-msg watch` handles DB-unreachable
fail-fast itself; no host-level prerequisites are required.

The lead shop's canonical `.claude/settings.json` still declares a
`SessionStart` hook for `bd prime` (short-lived, returns cleanly — a
legitimate synchronous hook usage); the activation hook itself has
moved to the router's Monitor invocation described here.

### Standing rule: reacting to Monitor events

`shop-msg watch --lead <name>` emits one line per new BC response, of
the form `<work_id> <message_type>`. The router's standing reaction for
each event:

- `<work_id> work_done` → dispatch **lead-architect** (reconciliation:
  confirm scenario register lands, hashes match, follow-up beads filed).
- `<work_id> clarify` → dispatch **lead-po** if the clarify is about
  scope or vocabulary; dispatch **lead-architect** if it is about
  architecture, contracts, or decomposition. If ambiguous, default to
  **lead-architect** and note the routing question.
- `<work_id> mechanism_observation` → dispatch **lead-architect**.

### Standing rule: idle-detection checklist

Before declaring the router idle, walk this enumerated checklist. If
any item surfaces work, that work is the next action — do not idle.

1. `shop-msg pending outbox --lead <name>` — any unprocessed BC
   responses?
2. `shop-msg pending inbox --lead <name>` — any BC `clarify` messages
   awaiting a lead-shop reply?
3. `bd` in-progress beads filtered by no-activity-window — any claimed
   beads that have stalled?
4. `bd ready` — any unblocked beads ready to claim?
5. Reconciliation queue — any `work_done` consumed where the scenario
   register has not yet been confirmed, hashes matched, follow-up beads
   filed? Cross-link any reconciliation previously marked blocked whose
   unblocker is now resolved.

Only when all five return empty is "idle" the correct posture.

### Standing rule: choice suppression

Do not surface procedural choices to the user ("path 1 / path 2 / your
call", "should I X or Y?"). Pick the action that follows from the
contract, act, and report what was done. Procedural choices belong to
the role discipline, not to the user.

**Carve-out — surface choices ONLY when the decision requires user
judgment:**

- **Scope or vocabulary** — a request that requires the user to decide
  what is in scope, or what a term means in product language.
- **PO / Architect routing for ambiguous clarifies** — when an inbound
  BC `clarify` could plausibly route to either lead-po (scope or
  vocabulary) or lead-architect (architecture, contracts,
  decomposition), surface the routing question. (Default per the
  Monitor-events standing rule is lead-architect; deviate only on
  user direction.)

Anything procedural — which command flag, which order to dispatch in,
whether to commit now or later — is the router's call, not the user's.

### Session-start drain

After arming Monitor and **before accepting user work**, the router must
check for pre-existing pending responses that arrived between sessions:

```
shop-msg pending outbox --lead <name>   # BC responses not yet consumed
shop-msg pending inbox  --lead <name>   # BC clarifies in the lead inbox
```

For each pending row, dispatch the appropriate subagent per the standing
rule above before turning to user requests. This drain prevents pile-up
across sessions.

## Router operations: inspecting BC responses

Two commands let the router discover and read BC responses without
touching mailbox storage directly:

- **List pending BC responses** (all BCs, or one filtered by canonical
  name):
  ```
  shop-msg pending outbox --lead <name> [--bc-name <bc>]
  ```

- **Read a specific BC response** by canonical BC name and work_id:
  ```
  shop-msg read outbox --bc <name> --work-id <work_id>
  ```

Note: `pending outbox` uses `--bc-name` for the optional BC filter;
`read outbox` uses `--bc`. Do not use the removed `--lead-root` or
`--bc-root` flags.

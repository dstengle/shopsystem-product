# {{SHOP_NAME}} — lead shop instructions

This repository is the **{{SHOP_NAME}}** lead shop. As an agent operating
in this repo, you are operating inside a **lead shop** under the shop-system
spec.

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
2. **Architect verifies the relevant BC's pre-state empirically.**
   Reading the BC's code is hypothesis; running it is fact. Construct a
   concrete input that exhibits (or fails to exhibit) the behavior;
   observe; cite the demonstration in the dispatch description.
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

## Session start: arming the BC-outbox watcher via the in-session Monitor

This shop is reactive on session start: when a BC drops a response
into one of its outbox directories, the router must learn about it
without polling. The activation mechanism is the in-session **Monitor**
tool — not a `SessionStart` hook in `.claude/settings.json`. (Earlier
iterations of this template tried the hook path; Claude Code awaits
`SessionStart` hooks synchronously, so a foreground `inotifywait -m`
pipeline never returns and session startup hangs. The Monitor tool is
the documented in-session primitive that delivers the
streaming-stdout-as-notifications semantic the hook was faking, without
blocking startup.)

**At session start, the router must arm the in-session Monitor tool on
the following pipeline (watch target: `repos/*/outbox/`):**

```
stdbuf -oL inotifywait -m -e create,moved_to repos/*/outbox/
```

Before arming the Monitor, the router must verify that both
`inotifywait` and `stdbuf` are on PATH (for example, via
`command -v inotifywait` and `command -v stdbuf`). If either executable
is missing, the router must refuse to arm the Monitor and surface a
visible diagnostic naming the missing prerequisite — do not silently
fall back to a no-watcher state, and do not arm the watcher via a
`SessionStart` hook in `.claude/settings.json` as a fallback. A
no-watcher session loses the shop's reactivity invariant; the operator
needs to see the diagnostic and install the missing package.

The lead shop's canonical `.claude/settings.json` still declares a
`SessionStart` hook for `bd prime` (short-lived, returns cleanly — a
legitimate synchronous hook usage); the activation hook itself has
moved to the router's Monitor invocation described here.

### Host prerequisites

The Monitor activation pipeline named above depends on two host-level
packages being present on PATH:

- **inotify-tools** — provides the `inotifywait` binary used to watch
  the per-BC outbox directories for new responses.
- **coreutils** — provides `stdbuf`, used to set line-buffered output
  on the `inotifywait` invocation so events stream as they happen
  rather than batching into a pipe buffer.

Install both packages through your distro's package manager (e.g.
`apt-get install inotify-tools coreutils` on Debian/Ubuntu).

# PDR-011 — "Verify pre-state empirically" means verify the contract surface, not BC code

**Status:** draft (2026-05-29)
**Authors:** dstengle, Claude (lead-po)
**Anchored to:** [PDR-004](004-bc-container-command-ownership.md) — *"work proceed through contracts and not reading code."*

## Point of intent

The primer tells the Architect to verify pre-state by reading and running BC code (`.claude/canonical/lead-primer.md:37-40`: "Reading the BC's code is hypothesis; running it is fact"), and reinforces it for the lead's own work (`.claude/shop/primer.md:49-50`). The only `repos/*` prohibition is on *edits* (`.claude/shop/primer.md:43`).

The gap: the prohibition forbids writing `repos/<bc>` but is silent on reading and executing it, while the empirical clause positively instructs both. The router acted on this — instructing `lead-architect` to `cd` into `repos/shopsystem-messaging` and `repos/shopsystem-scenarios` to read and run BC code (2026-05-29). That is the one thing BC-isolation exists to prevent.

The premise — "you cannot know pre-state without running the code" — is wrong for the lead. The lead's pre-state is the **contract / artifact surface**, knowable without any `repos/<bc>`. Per stakeholder direction (dave, 2026-05-29), the lead host carries **no BC source at all**: there is no `repos/` directory, nothing to read, run, or git-observe.

## Diagnosis

"Empirical" was conflated with "runs BC code." The property the clause wants is **demonstrated, not assumed**, and that is satisfiable against the contract surface:

- Scenario registration and hash: via `scenarios hash` and the BC's register.
- Whether a capability is pinned: from `features/` Gherkin and the scenario-to-BC mapping — that is the contract.
- What was sent/received/consumed and what a BC reported: via `shop-msg` mailbox state and the BC's `work_done` payload ([PDR-010](010-bd-authoritative-shop-msg-transport.md)).
- Whether a prior decision binds: from this repo's ADRs and PDRs.

Reading `repos/<bc>` adds only implementation detail the lead does not own, coupling the lead to BC internals — the coupling [ADR-004](../adr/004-bc-launcher-as-new-bc.md) and PDR-004 sever. If the Architect needs more than features/scenarios/ADRs can tell it, the answer is a `clarify` to the BC, not a `cd` into a clone.

## Decision

1. **"Verify pre-state empirically" = demonstrate the claim against the contract / artifact surface.** Hypothesis is still not fact; the demonstration is still cited in the dispatch description. Only the admissible evidence changes: artifact surface, not BC source or execution.

2. **No `repos/` directory on the lead host.** BC code never lives on the lead filesystem. BCs run as bc-launcher containers (cloned inside the container) and report via `shop-msg`. There is nothing to reach into.

3. **The may/may-not line.** The lead MAY read, run, and cite as pre-state: `features/` Gherkin; this repo's `adr/`, `pdr/`, `briefs/`; scenario hashes via `scenarios hash`; message schemas; `shop-msg` mailbox state; a BC's reported `work_done` demonstration. The lead MUST NOT read or execute a BC's implementation to establish behavior — there is no BC code on disk to read, run, or git-observe. Empirical proof requiring implementation execution is the BC's job, surfaced through its gated loop and reported via the mailbox.

4. **The BC demonstrates; the lead reconciles.** The BC produces its proof inside its container and reports it via `work_done`. The lead joins that against lead-side artifacts (register, hashes, ADRs, mailbox state) and never re-derives the proof.

5. **bc-launcher is the enabling mechanism; this PDR depends on it.** `shopsystem-bc-launcher` / the `bc-container` CLI ([ADR-004](../adr/004-bc-launcher-as-new-bc.md), [PDR-004](004-bc-container-command-ownership.md)) is what lets a BC run in isolation and report back, so the lead needs no clone. Until it is operational for a given BC, open question 3 governs.

## Follow-on canonical edits (Architect / ADR scope — named, not made)

- `.claude/canonical/lead-primer.md:37-40` — rewrite so "empirical" resolves to the contract/artifact surface, not BC code execution.
- `.claude/shop/primer.md:43` — broaden the `repos/*` rule: there is no `repos/` at all; no reading, running, or git-observing BC code.
- `.claude/shop/primer.md:35` — the `read outbox --bc-root repos/<bc>` example must re-point at the mailbox path (no clone).
- `.claude/shop/primer.md:49-50` — re-anchor "verified empirically" to this PDR.
- `.claude/shop/primer.md:60-61` — "Sibling BC clones ... repos/..." and "Role templates: repos/shopsystem-templates/..." must be purged or re-pointed at installed-package / mailbox paths.
- Any other `repos/` reference must be purged or re-pointed. The ADR owns the migration; these are the surfaces.
- The lead-primer is canonical and shipped by `shopsystem-templates`, so the revision propagates per [PDR-003](003-claude-md-update-propagation.md); keep the `.claude/agents/lead-architect.md` inline copy and the templates BC source in lockstep ([PDR-002](002-lead-shop-roles-as-subagents.md)).

## What this leaves open (for the Architect / ADR)

1. **Contract-tool execution.** `scenarios hash` is a contract tool whose input is Gherkin text and whose output is a contract fact. With no `repos/`, it must be an **installed (pip) package**, not run from a clone — and so needs no clone. The ADR must pin that contract CLIs are invoked as installed packages, distinct from executing a BC's implementation to observe its behavior.

2. **Pure test-infra / non-scenario tasks (e.g. lead-0bw).** When a task is internal test infra (conftest/fixture/test-DB) with no scenario hash to reconcile against, what does the lead reconcile on? Leaning: the BC's reported demonstration (CI/pytest result in `work_done`) plus mailbox state; never re-run the suite.

3. **Pre-bc-launcher transition.** With no clone to fall back to, what does the lead do for a BC not yet on bc-launcher? There is no containerized path and no source on disk. Pose it; the ADR owns the rule. Leaning: rely on the BC's reported `work_done`, never lead-side execution.

4. **Thin/absent reported evidence.** If `work_done` carries no usable demonstration, the lead's move is `clarify`/`nudge` back to the BC for the missing proof — never reaching for the proof itself. Pin as the standing fallback.

## Cross-references

- [PDR-004](004-bc-container-command-ownership.md) — anchor intent (*"work proceed through contracts and not reading code"*) made operative for lead pre-state verification.
- [ADR-004](../adr/004-bc-launcher-as-new-bc.md) — containerized execution that makes "the BC demonstrates, the lead reconciles" real.
- [PDR-010](010-bd-authoritative-shop-msg-transport.md) — same posture for transport: the lead reconciles on `shop-msg` emissions, not BC internals.
- [PDR-005](005-architect-technical-review-gate.md) — redefines the evidence the Architect's review gate consumes.
- [PDR-002](002-lead-shop-roles-as-subagents.md) — the `lead-architect` inline-copy relationship to keep in lockstep.
- [PDR-003](003-claude-md-update-propagation.md) — canonical-template propagation path for the lead-primer revision.
- [§3 Lead shop](../03-lead-shop.md) — the Architect pre-state activity this PDR re-grounds.

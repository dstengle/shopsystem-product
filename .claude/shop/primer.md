# shopsystem product — project-specific context

The product is the shopsystem framework itself; this repo is its outward face.

## Subagent dispatch specifics

The two subagent roles are dispatched per [PDR-002](pdr/002-lead-shop-roles-as-subagents.md):

- **Dispatch to `lead-po`** when the request requires: authoring or sharpening
  Gherkin scenarios; drafting briefs or PDRs; responding to BC `clarify` on
  scope or vocabulary.
- **Dispatch to `lead-architect`** when the request requires: selecting a
  message-type vehicle; composing `shop-msg send`; verifying BC pre-state
  empirically; responding to BC `clarify` on architecture; reconciling scenario
  registers; drafting ADRs; BC decomposition decisions.
- **Do NOT dispatch** for: routine git / beads / shell operations; reporting
  current repo state; conversational clarification of what was just done.
  Handle those in main-agent context.

Subagent definitions: [`.claude/agents/lead-po.md`](.claude/agents/lead-po.md)
and [`.claude/agents/lead-architect.md`](.claude/agents/lead-architect.md).
Per PDR-002 path (a) these are inline copies of the canonical templates in
`shopsystem-templates`; path (b) (`shop-templates` subagent export mode) is a
follow-up. Per [PDR-001](pdr/001-role-templates-role-complete.md) the templates
themselves are in revision.

## BC-shop loop and outbox inspection

The BC-shop loop (Implementer → Reviewer) runs inside each BC container, not
here. The lead shop's move is reconciliation when `work_done` arrives. To
inspect in-flight work:

- `shop-msg pending outbox --lead <name>` — list every BC's pending response.
- `shop-msg read outbox --bc <name> --work-id <work_id>` — read a specific
  BC response.

Do not reason about mailbox files directly; use these subcommands. There is
no `repos/<bc>` clone path to address — see "What does NOT happen in this
repo" below.

## What does NOT happen in this repo

- **No implementation code.** This is the lead shop; code lives in BCs.
- **No BC source on the lead host at all.** Per [ADR-018](adr/018-empirical-verification-is-contract-surface.md)
  (pinning [PDR-011](pdr/011-empirical-verification-is-contract-surface.md)),
  the lead carries no `repos/` directory: no reading, running, or
  git-observing BC code. BCs run as `bc-launcher` containers (cloned inside
  the container) and report via `shop-msg`. Cross-BC changes route through
  `assign_scenarios` / `request_bugfix`, not direct edits or reads.
- **No skipping the discriminator.** If a request smells like open-ended
  "what should we build?" — route it back through the process. First
  question: *what scenarios pin this?*
- **No proposing architecture before verifying current state empirically
  against the contract/artifact surface** (this repo's `features/`, `adr/`,
  `pdr/`, scenario hashes via the installed `scenarios hash` CLI, message
  schemas, `shop-msg` mailbox state, the BC's reported `work_done`
  demonstration) — per ADR-018 D1/D2. "Empirical" never means reading or
  running BC code; that proof is the BC's gated-loop job, surfaced via the
  mailbox. Applies to the lead shop's own work too.

## Where things live

- Framework spec: [§1](01-principles.md) – [§6](06-work-tracking.md).
- ADRs: [`adr/`](adr/).
- PDRs: [`pdr/`](pdr/).
- Canonical scenarios (PO-authored, dispatched to BCs): [`features/`](features/).
- Findings: [`findings/`](findings/).
- Role templates: shipped as package data by the installed `shopsystem-templates`
  distribution; inspect via `shop-templates show <role>`. There is no
  `repos/shopsystem-templates/` checkout on the lead host (ADR-018).
- BC code: never on the lead host. BCs run as `bc-launcher` containers
  (cloned inside the container) and report via `shop-msg`. To address a BC
  mailbox use `--bc <name>`, not a `repos/<bc>` path.

## Operational hygiene

**Session close.** Work is not done until `git push` succeeds. Before saying
complete: `git status` → `git add` → `git commit` → `bd dolt push` → `git push`
→ `git status` (verify "up to date with origin").

**Shell hygiene.** Use non-interactive flags (`cp -f`, `mv -f`, `rm -f`,
`apt-get -y`) so commands don't hang on interactive prompts.

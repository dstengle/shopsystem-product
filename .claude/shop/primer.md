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

The BC-shop loop (Implementer → Reviewer) runs in each BC's repo, not here.
The lead shop's move is reconciliation when `work_done` arrives. To inspect
in-flight work:

- `shop-msg pending outbox --lead-root .` — list every sibling BC's pending
  response.
- `shop-msg read outbox --bc-root repos/<bc> --work-id <work_id>` — read a
  specific BC response.

Do not reason about mailbox files directly; use these subcommands.

## What does NOT happen in this repo

- **No implementation code.** This is the lead shop; code lives in BCs.
- **No direct edits to `repos/*`.** Those are sibling BC repositories with
  their own remotes. Cross-BC changes route through `assign_scenarios` /
  `request_bugfix`, not direct edits.
- **No skipping the discriminator.** If a request smells like open-ended
  "what should we build?" — route it back through the process. First
  question: *what scenarios pin this?*
- **No proposing architecture before reading current state.** Pre-state
  determines vehicle, verified empirically. Applies to the lead shop's own
  work too.

## Where things live

- Framework spec: [§1](01-principles.md) – [§6](06-work-tracking.md).
- ADRs: [`adr/`](adr/).
- PDRs: [`pdr/`](pdr/).
- Canonical scenarios (PO-authored, dispatched to BCs): [`features/`](features/).
- Findings: [`findings/`](findings/).
- Role templates: `repos/shopsystem-templates/src/shop_templates/templates/`.
- Sibling BC clones (gitignored): `repos/shopsystem-{messaging,scenarios,templates,test-harness}/`.

## Operational hygiene

**Session close.** Work is not done until `git push` succeeds. Before saying
complete: `git status` → `git add` → `git commit` → `bd dolt push` → `git push`
→ `git status` (verify "up to date with origin").

**Shell hygiene.** Use non-interactive flags (`cp -f`, `mv -f`, `rm -f`,
`apt-get -y`) so commands don't hang on interactive prompts.

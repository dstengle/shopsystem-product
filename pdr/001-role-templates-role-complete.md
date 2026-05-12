# PDR-001 — Lead-shop role templates must be role-complete, identity-first

**Status:** draft (2026-05-12)
**Authors:** dstengle, Claude
**Anchored to:** PO intent expressed in conversation 2026-05-12:
*"The current architect prompt template is more of a skill for dispatching work."*

## Point of intent

A lead-shop role template (`lead-po.md`, `lead-architect.md`) must be a
**complete representation of the role** — identity, posture, ownership, the
full activity scope, and the judgment criteria that decide what is in or
out of the role's remit. The current templates are partial: they cover the
**subset** of activities that involve sending inter-shop messages, and miss
the remainder of the role's §3.2 activity catalogue entirely. As written
they read more as **skill manuals for the `shop-msg` CLI** than as **role
identities**.

## Diagnosis

Both templates do carry substantive posture — the Architect's `PRE-STATE
DETERMINES VEHICLE — VERIFIED EMPIRICALLY`, the PO's `COMMIT TO SPECIFICS`
— and that posture is real role content, not boilerplate. The gap is
**scope**: the posture and the procedural drill-down both apply only to the
message-sending and clarify-response activities. Comparing template content
against the §3.2 activity catalogue:

| Activity (§3.2) | Covered in template? |
|---|---|
| **PO** — Interview stakeholder | No |
| **PO** — Maintain product brief | No |
| **PO** — Write PDR for new functionality | No |
| **PO** — Write Gherkin scenarios | Yes (sufficiency check, anti-rationalization) |
| **PO** — Respond to BC `clarify` (scope, vocabulary) | Yes |
| **Architect** — Write ADRs | No |
| **Architect** — Maintain structurizr workspace | No |
| **Architect** — Collaborate with PO on BC decomposition (turn-limited) | No |
| **Architect** — Assign scenarios to BCs | Yes (dominant content) |
| **Architect** — Reconcile scenario registers against assigned work | No |
| **Architect** — Send `request_bugfix` / `request_maintenance` | Yes |
| **Architect** — Read a BC-shop's card via `request_shop_card` | No |
| **Architect** — Respond to BC `clarify` (architecture) | Yes |

An agent that loads `lead-architect.md` today is well-equipped to dispatch
the next outbound message but uninformed about its role's other named
activities. The asymmetry is not "skill content vs identity" — it is
"covered activities vs un-covered activities."

## Decision

Lead-shop role templates SHALL:

1. **Lead with identity and posture that hold across the role's full §3.2
   activity catalogue** — not only the subset that involves sending
   inter-shop messages. The posture statements that exist today are good
   models for what other activities also need.

2. **Name every activity the role owns per §3.2**, even if the template's
   first version only carries minimal guidance for some of them. Activities
   without sufficiency criteria yet should be marked as such, so an agent
   loading the template knows the activity is in scope even if the
   discipline is still developing.

3. **Subordinate procedural CLI content** (specific `shop-msg send` flag
   layouts, sufficiency-check ordering for a given message type) to the
   role identity. Procedural content is recoverable from a CLI's `--help`;
   identity and posture are not.

## What this leaves open

- **Concrete restructure of `lead-architect.md` and `lead-po.md`** is BC
  work — the templates live in
  [`shopsystem-templates`](https://github.com/dstengle/shopsystem-templates).
  The lead shop authors Gherkin scenarios pinning what the restructure must
  satisfy and dispatches via `assign_scenarios`. Scenario authoring is a
  follow-up; this PDR records intent, not the scenarios themselves.

- **The parallel question for `bc-implementer.md` / `bc-reviewer.md`**
  (do BC-shop templates have the same partial coverage against §4.2?) is
  open. Prototype-1 validated the role-template *architecture*, not
  necessarily the *coverage* of each template against its activity
  catalogue. A second PDR may answer this once Stage-1 of the templates
  restructure produces evidence.

## Cross-references

- [§3.2 Lead-shop activities](03-lead-shop.md#32-activities) — the
  authoritative activity catalogue this PDR measures against.
- [`repos/shopsystem-templates/src/shop_templates/templates/lead-architect.md`](repos/shopsystem-templates/src/shop_templates/templates/lead-architect.md)
- [`repos/shopsystem-templates/src/shop_templates/templates/lead-po.md`](repos/shopsystem-templates/src/shop_templates/templates/lead-po.md)

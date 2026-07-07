---
id: PDR-014
kind: pdr
title: "Canonical lead skill-group: `shop-templates` pours it, and it is the graduation path for experimental lead skills"
status: draft
date: "2026-06-05"
description: "Canonical lead skill-group: `shop-templates` pours it, and it is the graduation path for experimental lead skills"
beads: [lead-3nf7, lead-po]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: []
  pins: []
  related: []
---
# PDR-014 — Canonical lead skill-group: `shop-templates` pours it, and it is the graduation path for experimental lead skills

**Status:** draft (2026-06-05)
**Authors:** dstengle, Claude (lead-po)
**Anchored to:** Operator intent expressed 2026-06-05 (bead **lead-3nf7**):
*"bring up BCs with `bc-container`; **bake the procedure into the lead
templates as a skill**."* The "bake" half of that request is the point of
intent here; the "bring up" half is the `bring-up-bc` skill that already
exists experimentally in `.claude/skills/`.

## Point of intent

Baking a skill into the **canonical lead template** requires a capability the
`shopsystem-templates` BC does not yet have. This PDR records the intent to add
it, and names what it must do — as **intent, not implementation** (per
[PDR-001](001-role-templates-role-complete.md) the concrete `shop-templates`
implementation is BC work the Architect dispatches via `assign_scenarios`).

## Empirical finding (the gap this closes)

There is **no poured lead skill-group mechanism** in `shop-templates` today.
Verified against the contract/artifact surface (ADR-018):

- `shop-templates bootstrap` pours the **role templates** (`features/templates/30`),
  **`.claude/settings.json`** (`features/templates/60`), and the
  **`.claude/canonical/<type>-primer.md`** primer (`features/templates/81`) —
  each byte-for-byte from package data.
- **No `features/` scenario pins a poured skill-group.** The "skill-group
  poured" line that appears at BC launch is a **`bc-launcher` behavior for BC
  *containers*** (the launcher pours into `/workspace` inside the container),
  not a `shop-templates` bootstrap behavior — and **the lead shop is not a
  launched container**. So `bc-launcher`'s pour cannot reach the lead's
  `.claude/skills/`.

Therefore "bake `bring-up-bc` into the lead template" is a **new
`shopsystem-templates` capability**, not a use of an existing one.

## The capability to pin

1. **`shop-templates` ships a canonical lead skill-group as package data** —
   parallel to how it already ships role templates, `settings.json`, and the
   primer — accessible through its public template-access surface.
2. **`shop-templates bootstrap --shop-type lead` pours that skill-group** into
   the target's `.claude/skills/`, each skill as
   `.claude/skills/<name>/SKILL.md`, **byte-for-byte from package data** — the
   same pour discipline as the other canonical files (features 30 / 60 / 81).
3. **`shop-templates update` re-pours / aligns the managed skill-group** —
   idempotent when current, replaces drift — consistent with how `update`
   treats other managed files (features 35–43).
4. **`bring-up-bc` is the first member** of the canonical lead skill-group. Its
   canonical body names: launching a BC via **`bc-container launch`**; setting
   **`BCLAUNCHER_HOST_HOME`** for a devcontainer with a bind-mounted home; and
   **verifying the BC reaches `online` via `shop-msg bc-status`**.

## The graduation path (PDR-012 dependency this satisfies)

[PDR-012](012-lead-po-product-manager-scope-and-architect-structurizr-maintenance.md)
adopts the PM (and lead-operational) skills **experimental-first**: a skill
lives in `.claude/skills/` and is proven in real lead work *before* the
canonical template owns it. PDR-012 (and `.claude/skills/README.md`, "How a
skill graduates") names the graduation step — pin by Gherkin, dispatch via
`assign_scenarios` to the templates BC so the canonical lead template owns it —
but **no mechanism existed for the template to *carry* a skill.** This
capability **is that mechanism.** The canonical lead skill-group is the
graduation **destination**: a proven experimental skill graduates by being
added to this group, after which every bootstrapped lead shop ships it.

**Scope discipline (do not over-commit):** this PDR pins only that (a) the
mechanism exists and (b) **`bring-up-bc` is the first graduated member.** The
PM skills (jobs-to-be-done, opportunity-solution-tree, etc.) remain
**experimental** per PDR-012 and are **not** enumerated as members here. They
graduate one at a time, each by its own scenario, once proven — that is the
point of the path, not a bulk import (cf. PDR-012 option (A), rejected).

## Options considered

- **(A) Reuse `bc-launcher`'s skill-group pour for the lead.** Rejected: the
  lead is not a launched container; `bc-launcher` pours into `/workspace`
  inside a BC container at launch. There is nothing to reuse for a lead shop's
  on-disk `.claude/skills/`.
- **(B) Hand-place `bring-up-bc` in each lead repo and never bake it.**
  Rejected: it never graduates, drift is unmanaged, and PDR-012's graduation
  path stays a dead letter. The skill stays experimental forever.
- **(C, chosen) Add a canonical lead skill-group poured by `bootstrap` and
  realigned by `update`, byte-for-byte from package data — the same discipline
  as every other canonical managed file.** Matches the established
  bootstrap-pour / update-realign family (features 30/35/36/43/60/81), and
  doubles as the PDR-012 graduation destination. Implementation is BC work
  dispatched via `assign_scenarios` per PDR-001's division of labor.

## Decision

1. `shopsystem-templates` SHALL ship a **canonical lead skill-group** as
   package data, accessible through its public template-access surface.
2. `shop-templates bootstrap --shop-type lead` SHALL **pour** that skill-group
   into the target's `.claude/skills/`, one `SKILL.md` per skill, byte-for-byte
   from package data.
3. `shop-templates update` SHALL **re-pour / align** the managed skill-group —
   idempotent when current, replacing drift — consistent with the update family.
4. **`bring-up-bc` SHALL be the first member**, its canonical body naming
   `bc-container launch`, `BCLAUNCHER_HOST_HOME` (devcontainer bind-mounted-home
   gotcha), and the `shop-msg bc-status` online check.
5. The canonical lead skill-group SHALL be the **graduation destination** for
   experimental lead skills (PDR-012): graduation = adding a proven skill to
   this group. PM skills are **not** enumerated as members yet.
6. This PDR is **intent, not implementation.** The concrete `shop-templates`
   implementation — package-data layout, pour code, update-realign code — is
   BC work the Architect dispatches via `assign_scenarios`. The accompanying
   scenarios (`features/templates/159`–`164`) pin the requirements.

## What this leaves open

- **The package-data directory layout** for the canonical lead skill-group
  inside the `shopsystem-templates` distribution is a templates-BC
  implementation decision; the scenarios pin *that* it pours byte-for-byte and
  *where it lands in the target*, not the source layout.
- **Whether the skill-group is shop-type-scoped** (a distinct group per shop
  type) or lead-only is left to the BC; this PDR commits only to the **lead**
  group and `--shop-type lead` pour. (BC containers already get their pour from
  `bc-launcher`; this capability is the lead-side parallel.)
- **The concrete PM-skill members** graduate later, each by its own scenario
  once proven per PDR-012; none are committed here beyond `bring-up-bc`.

## Cross-references

- [§3.3 Artifacts owned](03-lead-shop.md#33-artifacts-owned) — the lead-owned
  artifacts; the skill-group is a new canonical managed artifact poured by the
  templates BC, parallel to the primer and role templates.
- [PDR-001](001-role-templates-role-complete.md) — template content is BC work
  owned by `shopsystem-templates`; this PDR follows that division of labor.
- [PDR-012](012-lead-po-product-manager-scope-and-architect-structurizr-maintenance.md)
  — experimental-first skill adoption and the graduation path this capability
  realizes; `.claude/skills/README.md` "How a skill graduates."
- The **bootstrap-pour / update-realign family**:
  `features/templates/30, 35, 36, 43, 60, 81` — the house style these scenarios
  match.
- Bead **lead-3nf7** — the operator request and the bake-mechanism finding.

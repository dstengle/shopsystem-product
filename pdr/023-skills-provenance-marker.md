---
id: PDR-023
kind: pdr
title: "Skills provenance marker: re-pour overwrites only CANONICAL skills, LOCAL skills survive every re-pour"
status: draft
date: "2026-06-27"
description: "Skills provenance marker: re-pour overwrites only CANONICAL skills, LOCAL skills survive every re-pour"
beads: [lead-22x1, lead-po, lead-vme1]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: [PDR-014]
  pins: []
  related: []
---
# PDR-023 — Skills provenance marker: re-pour overwrites only CANONICAL skills, LOCAL skills survive every re-pour

**Status:** draft (2026-06-27)
**Authors:** dstengle (product authority), Claude (lead-po)
**Anchored to:** Product-authority directive captured 2026-06-27 on bead
**lead-vme1**. Scope and product vocabulary (CANONICAL vs LOCAL, EXPERIMENT,
the MIGRATION PATH) are **pinned by that directive** — this PDR records the
decision, it does not re-open discovery. Relates **lead-22x1** (WS-7 skills
corpus) and supersedes the by-name membership mechanism pinned by PDR-014.

## Point of intent

The lead-owned discovery/PM skills (`jobs-to-be-done`,
`problem-framing-canvas`, `opportunity-solution-tree`,
`customer-journey-map`, `company-research`, `work-splitting`, and the skills
`README`) were **collaterally deleted twice** — once by the v0.13.0 re-pour
(commit `b573851`) and again by the `84df061` backlog sweep — because they
live **only in the lead working tree, never in templates**, and the
pour/sweep had no way to distinguish framework (canonical) skills from local
experiments. They were restored to the lead at `5671c96` (live). Only
`bring-up-bc` and `create-bc` are canonical (`templates/lead_skills`).

The recurrence is the tell: this is a **mechanism gap**, not an operator
mistake. The pour cannot be trusted with the lead's local skills until it can
tell canonical from local by an explicit, durable, discoverable declaration —
not by a name heuristic.

## Empirical finding (the gap this closes)

Verified against the contract/artifact surface (ADR-018), templates HEAD
`ece0dca`:

- `cli.py` `_mirror_skills` (around **L506**, landed by bead `lead-1e8d`,
  superseding scenario **159 / `9a064e8f6ed915e3`** —
  `features/templates/159-update-scopes-skill-pruning-to-canonical-members-so-unmanaged-skill-dirs-survive.gherkin`)
  **already preserves unmanaged skills**: pruning is scoped so that a skill
  directory whose name is **not** a canonical member survives a re-pour
  byte-for-byte. This is real protection and the first half of the fix.
- **But the membership test is BY NAME.** `managed_members` is the set of
  canonical top-level directory names. Two consequences follow:
  1. **Fragility on name collision.** A *local* skill that happens to share a
     name with a canonical member is classified canonical and **clobbered** on
     the next pour. The protection has a silent hole exactly where a durable
     local skill is most likely to land (an operator localizing a skill keeps
     its familiar name).
  2. **Not discoverable.** There is **no provenance marker** on disk. Neither a
     human nor an agent can look at a skill directory and know whether the
     pour considers it canonical or local. The canonical/local distinction
     lives only as a name set inside `cli.py`, invisible at the artifact
     surface.

The by-name test is therefore the current behavior this PDR **supersedes**: the
pour must decide what to overwrite from a per-skill provenance marker, not from
the directory name.

## The provenance-marker design (the capability to pin)

1. **Per-skill provenance marker file.** Each skill directory carries a
   provenance marker file — `.claude/skills/<name>/.provenance` — that
   **declares the skill CANONICAL or LOCAL**. The marker is the single source
   of truth for the pour's overwrite decision and is **discoverable** at the
   artifact surface by humans and agents alike.

2. **The pour decides from the marker, not the name.** `shop-templates`
   bootstrap/update SHALL classify each target skill directory by reading its
   `.provenance` marker:
   - **CANONICAL** → the pour **owns** the skill: it re-pours the canonical
     body byte-for-byte from package data (idempotent when current, replacing
     drift), and the poured directory carries a `.provenance` marker declaring
     CANONICAL.
   - **LOCAL** → the pour **never touches** the skill: body and marker survive
     every re-pour byte-for-byte, **even when the directory name collides with
     a canonical member**. This closes the by-name hole.

3. **Backward-compatible default for an absent marker (transition rule).** A
   target skill directory with **no** `.provenance` marker is classified by the
   legacy by-name rule for one transition: a directory whose name **is** a
   canonical member is treated CANONICAL (and the pour installs its marker on
   the next run); a directory whose name is **not** a canonical member is
   treated LOCAL and preserved. An explicit marker **always overrides** the
   name default — to localize a skill that shares a canonical name, an operator
   writes a LOCAL marker, and the pour honors it.

4. **Three supported lifecycles** (the directive's point 3):
   - **EXPERIMENT** — drop a LOCAL skill into `.claude/skills/`; it persists
     across every re-pour with no further ceremony (the twice-lost PM skills
     are exactly this).
   - **Durable LOCAL** — a long-lived local skill, including one whose name
     collides with a canonical member, survives indefinitely by its LOCAL
     marker.
   - **MIGRATION PATH (graduate LOCAL → CANONICAL)** — a proven local skill
     graduates by (a) **adding its body to the canonical templates package
     data** and (b) **flipping its `.provenance` marker to CANONICAL**. After
     the flip the pour manages it like any other canonical member: subsequent
     `update` re-pours it from package data. This is the PDR-014 graduation
     path made executable at the marker level.

## Options considered

- **(A) Keep the by-name test; add no marker.** Rejected: leaves the
  name-collision hole open (a durable local skill keeping a canonical name is
  silently clobbered) and leaves the canonical/local distinction invisible at
  the artifact surface. This is the status quo that lost the PM skills twice.
- **(B) A single central manifest listing local skills.** Rejected: a central
  list drifts from the directories it describes, is not co-located with the
  skill it governs, and is not discoverable by an agent reading one skill
  directory. The directive specifies a **per-skill** marker for exactly this
  co-location/discoverability reason.
- **(C, chosen) Per-skill `.provenance` marker; pour overwrites only
  CANONICAL; LOCAL survives every re-pour; migration = add-to-templates +
  flip-the-marker.** Matches the directive verbatim, co-locates provenance with
  the skill, makes the distinction discoverable, and closes the by-name hole.

## Decision (product authority, verbatim points 1–3)

1. **Re-pour OVERWRITES ONLY CANONICAL skills; LOCAL skills survive every
   re-pour.**
2. **A provenance MARKER FILE per skill declares CANONICAL vs LOCAL — the pour
   decides what to overwrite from the marker, not by name.**
3. **Support EXPERIMENT (drop a local skill, it persists), durable LOCAL
   skills, and a MIGRATION PATH (graduate local → canonical: add to templates,
   flip the marker).**

This PDR is **intent, not implementation.** The concrete `shopsystem-templates`
work — the `cli.py` skill-render/`_mirror_skills` change to read the marker, and
shipping the canonical `.provenance` marker for `bring-up-bc` and `create-bc` in
package data — is BC work the Architect dispatches via `assign_scenarios` /
`request_bugfix` per PDR-001's division of labor. The scenarios below pin the
requirements.

## Sequencing

The directive pins the order and this PDR holds it:

1. **The marker mechanism ships FIRST** — `shopsystem-templates` reads the
   `.provenance` marker, overwrites only CANONICAL, and ships the canonical
   marker for `bring-up-bc` and `create-bc`.
2. **THEN the restored PM skills are marked LOCAL** — once the pour honors LOCAL
   markers, the restored `jobs-to-be-done`, `problem-framing-canvas`,
   `opportunity-solution-tree`, `customer-journey-map`, `company-research`,
   `work-splitting`, and the skills `README` get LOCAL markers so they are
   protected by mechanism, not by luck.

Marking the PM skills LOCAL **before** the pour honors the marker would protect
nothing; doing it after is durable. The sequencing is load-bearing.

## What this leaves open

- **The marker file's exact serialization** (a bare token line, a small
  key/value, or a front-matter field) is a templates-BC implementation
  decision; the scenarios pin **that** the marker exists at
  `.claude/skills/<name>/.provenance`, **declares** CANONICAL vs LOCAL, and
  **drives** the overwrite decision — not the byte layout of the declaration.
- **The package-data location** of the canonical `bring-up-bc`/`create-bc`
  markers inside the `shopsystem-templates` distribution is the BC's choice,
  parallel to PDR-014's open layout question.

## Cross-references

- [PDR-014](014-lead-skill-group-pour-and-graduation-path.md) — the canonical
  lead skill-group pour and the graduation path this PDR makes executable; its
  by-name membership mechanism is what this PDR supersedes.
- [PDR-012](012-lead-po-product-manager-scope-and-architect-structurizr-maintenance.md)
  and `.claude/skills/README.md` — experimental-first adoption and "How a skill
  graduates," the lifecycle the marker now protects.
- [ADR-018](adr/018-empirical-verification-is-contract-surface.md) — the
  contract/artifact surface against which the templates HEAD `ece0dca` /
  `_mirror_skills` L506 pre-state was verified.
- **Pre-state scenario** `features/templates/159` (`9a064e8f6ed915e3`) — the
  by-name pruning scope this PDR's scenarios supersede with marker-driven
  classification.
- Bead **lead-vme1** — the product-authority directive; **lead-22x1** (WS-7
  skills corpus); **lead-1e8d** (the `_mirror_skills` by-name pruning that
  landed).
</content>
</invoke>

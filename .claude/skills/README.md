# Lead skills (operations)

This directory holds the lead shop's **operational** skills. The PM
technique/research skills that previously lived here were **removed** — see the
license note below.

## ⚠️ Removed: deanpeters-derived PM technique skills (license-incompatible)

On 2026-07-10 all PM technique/research skills adapted from
[`deanpeters/Product-Manager-Skills`](https://github.com/deanpeters/Product-Manager-Skills)
were **removed** from this repo. Diligence on ingestion found the upstream is
licensed **CC-BY-NC-SA 4.0** (Attribution–**NonCommercial**–**ShareAlike**),
which is **incompatible with this repo's MIT license**:

- **ShareAlike** would force any *derivative* of that material to be
  CC-BY-NC-SA — it cannot be relicensed MIT.
- **NonCommercial** contradicts MIT's grant of commercial use.

The removed skills (`jobs-to-be-done`, `opportunity-solution-tree`,
`problem-framing-canvas`, `customer-journey-map`, `company-research`,
`work-splitting`, and the 15 technique skills adopted 2026-07-10) were derived
from that source and are therefore not distributable under MIT.

**If PM technique skills are wanted, author them CLEAN-ROOM** from the *primary*
public frameworks — JTBD (Christensen/Ulwick), Opportunity Solution Tree
(Torres), PESTEL, MoSCoW, Kano, Amazon working-backwards, etc. Methods and
frameworks are **not copyrightable**; only a specific author's expression is. A
skill written in original words from the primary technique — **not** derived
from deanpeters' files — is clean MIT, with no attribution/NC/SA obligation.

The six canonical PM **session** skills (discovery-dialogue, shaping,
option-tradeoff, prioritization, problem-space-mapping, product-narrative) are
**shop-authored** (not deanpeters-derived) and ship from `shopsystem-templates`
via the PDR-033 pour — they are unaffected by this removal.

## Canonical PM session skills (poured, bootstrap-managed)

Poured from `shop-templates` v0.51.0 via `shop-templates update` (PDR-033
re-render). These are **canonical** (owned by the `shopsystem-templates` BC) —
do not hand-edit; they re-pour on update. Each is a session skill with a
mandatory terminal artifact:

| Skill | Terminal artifact |
|---|---|
| `discovery-dialogue` | intent record |
| `shaping` | candidate (→ shaped) |
| `option-tradeoff` | PDR draft / sibling candidates |
| `prioritization` | prioritization record |
| `problem-space-mapping` | problem-space map revision |
| `product-narrative` | README / site / current-state revision |

## Operational skills (shop-authored, clean)

| Skill | What it does |
|---|---|
| [`bring-up-bc`](bring-up-bc/SKILL.md) | instantiate a BC as a running container via `bc-container` so the lead can dispatch to it |
| [`create-bc`](create-bc/SKILL.md) | create a new BC from scratch — scaffold, remote, manifest, brokered launch |

---
id: BRIEF-012
kind: brief
title: "Brief 012 — Adopter bootstrap: from \"Use this template\" to a product on its own footing"
status: draft
date: "2026-06-18"
description: "Brief 012 — Adopter bootstrap: from \"Use this template\" to a product on its own footing"
beads: [lead-5cgv, lead-integration, lead-po, lead-shop, lead-y73x]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: []
  pins: []
  related: []
---
# Brief 012 — Adopter bootstrap: from "Use this template" to a product on its own footing

**Status:** draft (2026-06-18)
**Authors:** dstengle (stakeholder), Claude (lead-po)
**Lead bead:** [`lead-5cgv`](#) — *Lead skill: stand-up-product* (the FINAL
discussion decisions, 2026-06-18, are recorded in that bead's notes and are
authoritative for this brief). Grounding finding:
[`findings/adopter-journey-exploration-2026-06-18.md`](../findings/adopter-journey-exploration-2026-06-18.md)
(bead [`lead-y73x`](#)).

**Anchored to:** the FINAL discussion decisions on lead-5cgv (dave, 2026-06-18),
which REFRAME the bead's original "lead orchestrates bring-up from a
plain-language request" framing. That framing conflated two phases; this brief
operationalizes the split dave settled. The decisions below are settled — this
brief does not re-litigate them and does not widen scope.

**Cross-links (decisions this brief builds on — NOT re-decided here):**

- [Brief 011](011-new-product-bootstrap-path.md) — the authoritative
  empty-dir→working-product walk. Brief 012 is the *bootstrap-capability*
  reframe of that walk: 011 documents the six manual steps; 012 commits the
  phased capability that makes the footing deterministic and names where the
  plain-language orchestration actually lives.
- [Brief 007](007-end-user-adoption-documentation.md) — the adopter persona
  and the zero-host-install commitment (Docker + a GitHub account, no
  framework tools on the host). Q7 (launcher gap) is the open question this
  brief's Footing phase answers concretely.
- [ADR-026](../adr/026-agent-vault-brokered-credentials-eliminate-host-filesystem-coupling.md)
  / [ADR-028](../adr/028-agent-vault-broker-is-a-lead-shop-supporting-service-broker-own-behaviors-pinned-by-lead-integration-surface.md)
  — the agent-vault broker as a per-shop supporting service; the one human
  credential gate.
- [ADR-038](../adr/038-manifest-product-field-is-the-canonical-product-identity-source.md)
  — the manifest `product:` field as the single declared product identity.

---

## 1. The problem — the front door promises a capability that does not exist

The adopter-bootstrap journey finding (lead-y73x) names the problem precisely,
as an observed dip, not a guess:

> **At Stage 3 — the moment the adopter does exactly what the front door
> instructed ("just brief the lead in plain language to stand up your product")
> — the lead cannot yet carry the request through to a standing product.**

The front door promises the adopter stands up a product of their own from an
empty start. In reality the lead is a router with no skill that takes a
plain-language "stand up my product" and drives services-up → broker-provision
(through the human gate) → first BC. The adopter is **silently dropped into the
manual six-step walk** the front door told them they would not have to run. This
is a missing *capability*, not a documentation gap.

Two moments-of-truth dominate the journey and this brief targets both:

- **Stage 3 — the capability/promise dip (the first and deepest).** It is a
  promise-vs-delivery gap; failing it poisons trust for every later stage.
- **Stage 5 — the credential-gate wall.** The single most identity-coupled,
  least-recoverable step (observed WALL-2: `proposal create` rejected for
  "Session requires vault scope"). The gate is real, sharp, and must be walked,
  not papered over.

The outcome this brief targets — stated as an observable behavior change, not a
deliverable: **an adopter who has only Docker and a GitHub account reaches a
product of their own on solid footing (green `git push` + `bd dolt push`)
without hand-wiring messaging, credentials, or containers, and without ever
touching `shopsystem-product`.** Output volume (a script, a starter repo) is not
the measure; the adopter standing on their own footing is.

---

## 2. The phased solution shape

The reframe dave settled splits the bootstrap into three phases. The boundary
between Footing and Discovery is the load-bearing decision: the footing is a
**deterministic script with no agent**; the orchestration the front door
promised lives in **Discovery**, an explicit next step the adopter runs.

### Phase 1 — Footing (deterministic, NO agent)

**Zero install of our software. The adopter never touches `shopsystem-product`.**

- **Entry = "Use this template" on a tiny `shopsystem-starter` repo.** The
  starter carries only: `compose` (the rendered supporting services), a
  deterministic bootstrap script, `.env.example`, and a README. It contains
  **NO framework code** — framework code lives ONLY in the published image.
  "Use this template" produces the adopter's own `<product>-lead` repo.
- **The bootstrap script is deterministic and reliable.** Its one
  non-deterministic beat is the single human auth gate. The script:
  1. pulls a published image (framework code lives there);
  2. brings up postgres + agent-vault;
  3. runs ONE up-front human auth gate — Claude + GitHub, consolidated;
  4. pours the lead structure via `shop-templates bootstrap` from the image;
  5. creates `<product>-lead-beads`;
  6. wires the git + beads remotes;
  7. **ENDS at solid footing** = green `git push` + `bd dolt push`, then STOPS.

Framework code never lands in the adopter's repo: the starter is compose +
script + env-example + README; everything else is rendered from the image.

### Phase 2 — Discovery (agent-driven, the EXPLICIT next step the adopter runs)

A brokered Claude / PM session that **defines the product** —
problem-framing → JTBD → journey-map → brief/PDR. **This is where "the lead
orchestrates from a plain-language request" actually lives.** It is a separate,
explicit step the adopter runs *after* footing; it is NOT part of the bootstrap
script.

### Phase 3 — BC creation (a later, third step)

Standing up the product's first BC is the third step, after Discovery has
defined what to build. Optional within this phase: an example throwaway-product
chat, used purely as illustration of the Discovery → BC-creation flow.

---

## 3. Naming convention (tooling-enforced)

- Lead repos: `<product>-lead` / `<product>-lead-beads`.
- BC repos: `<product>-<bc>` / `<product>-<bc>-beads`.

**Only the lead repo name is user-chosen** (it is the one repo the adopter
creates by hand via "Use this template"). Everything else is tooling-created, so
the convention is enforced for free. For the one user-chosen name, the bootstrap
script:

1. **validates** the repo name against the `*-lead` shape;
2. **derives** `<product>` from it;
3. if the name does not match, **offers to `gh repo rename`** — a
   rename-after-the-fact, NOT a re-fork.

All other repos (`<product>-lead-beads`, every `<product>-<bc>` /
`<product>-<bc>-beads`) are created by tooling under the derived `<product>`, so
they cannot drift from the convention.

---

## 4. Constraints / principles (dave set these — load-bearing)

- **Zero-install.** No framework software is installed on the adopter's host;
  the adopter never touches `shopsystem-product`.
- **Minimal prerequisites.** Docker + a GitHub account. Nothing else.
- **Deterministic script PREFERRED over an agent for footing.** The footing
  must be reliable and repeatable; an agent is the wrong tool for it. The agent
  enters only at Discovery.
- **Credentials up front, consolidated to ONE gate.** The single human auth
  beat (Claude + GitHub) happens once, early, in the script — not scattered
  across later steps. This directly targets the Stage-5 wall.
- **No `shopsystem-product` confusion.** The adopter's entry is the
  `shopsystem-starter` template, not this product's repo; the two must not be
  conflated.
- **Keep it non-magical.** The whole footing is a template fork plus a readable
  script living in the user's own repo. The adopter can read exactly what the
  script does; nothing is hidden behind an opaque agent.

---

## 5. Out of scope / deferred

- **The two-phase throwaway-container idea is a SEED, not a committed
  decision.** Recorded here as a non-committed option only; it is not a
  decision and nothing in this brief depends on it.
- **Discovery "next" UX detail** — the exact shape of how the adopter is handed
  into the Discovery session — is a follow-on, not committed here.
- **The example throwaway-product chat** (Phase 3 illustration) is optional and
  a follow-on.
- **BC creation mechanics** beyond naming this as the third step are a follow-on
  (it pairs with the separate create-bc capability, lead-okre / create-bc).

This brief deliberately does NOT widen into Discovery UX, BC-creation mechanics,
or the throwaway-container model. It commits the Footing phase shape, the phase
boundaries, the naming enforcement, and the constraints — and names the rest as
explicit follow-ons.

---

## 6. Open questions (genuinely undecided — flagged, not invented)

Per COMMIT-TO-SPECIFICS: everything dave settled is committed above. These are
the genuinely-open product questions surfaced for resolution rather than
guessed at. They are product/scope questions for the stakeholder or
architecture questions for the Architect's PDR; the PO does not pre-decide
them.

1. **Claude auth via a non-interactive script — is the dashboard-set refreshing
   OAuth credential expressible inside a deterministic script?** ADR-026 D2's
   provisioning caveat says the refreshing Claude OAuth credential type is set
   in the agent-vault dashboard, not via the CLI surface. The footing commits a
   *single deterministic script* whose only non-deterministic beat is the human
   gate. Whether that gate can be a one-shot in-script paste/approve, or must
   still route the human to the dashboard, is open and material to "one gate,
   in the script." (Architecture-leaning; for the PDR.)

2. **Image lineage for the starter — is the published image a new
   lead-bootstrap image or the existing `bc-base` lineage?** The footing pulls
   "a published image" carrying the framework code. Whether that is a new
   purpose-built image or an extension of the current `bc-base` lineage (and at
   what pin) is an architecture/decomposition call for the PDR, not settled in
   this brief.

3. **Does the starter `compose` reference a fixed published image tag, or does
   the script resolve the tag at run time?** The journey finding ranks stale
   image tags as a real (if mild) pain (P4 / `:latest` lag). Whether the
   deterministic footing pins the tag in `compose` or resolves it in the script
   affects reproducibility vs. staleness. (Architecture-leaning; for the PDR.)

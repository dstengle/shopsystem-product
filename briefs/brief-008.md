---
type: brief
id: brief-008
title: 'Single-container bootstrap orchestrator (slice 1: lead-only prove-out)'
status: draft
created: 2026-05-22
updated: 2026-07-17
authors: [dstengle, Claude (lead-po)]
description: '**Slice 1: prove out launching and bootstrapping the lead shop in a'
derives-from: []
---

## Summary

## Scope

## Source (pre-modernization)

#### What this brief commits — slice 1 only

**Slice 1: prove out launching and bootstrapping the lead shop in a
container, using primitives that already exist.**

That is the entirety of this brief's capability commitment. Concretely:

- An adopter (or, equivalently, the framework's own test posture) can
  bring up a **lead-shop container** — a container in which a lead-shop
  working tree is scaffolded and ready for a Claude Code session — using
  **docker compose** as the composition primitive. Docker compose is
  already used by the framework today
  ([`repos/shopsystem-devcontainer/docker-compose.yml`](../repos/shopsystem-devcontainer/docker-compose.yml)
  declares the postgres service); slice 1 extends that pattern, it does
  not introduce a new composition mechanism.
- The lead-shop container does its own first-run bootstrap **from
  inside**: the container's entrypoint (or compose-driven init step)
  runs the existing `shop-templates bootstrap --shop-type lead
  --shop-name <product>` against a mounted working directory, so the
  adopter does not have to install `shop-templates` on their host.
- Postgres comes up alongside — same compose file, same `shopsystem`
  Docker network, same image as today. Slice 1 does NOT reinvent
  postgres bring-up; it composes the existing postgres service.
- BCs are explicitly **not** in slice 1's scope. After slice 1 lands, an
  adopter has a running lead-shop container and a running postgres; they
  do not yet have BC containers running. BC bring-up is slice 2+
  territory.

The point of slice 1 is to **test the assumption** that the framework's
existing primitives (docker compose + the postgres compose service +
`shop-templates bootstrap --shop-type lead`) actually compose into a
working lead-in-a-container experience, with whatever new piece is
needed to launch the lead container itself (see brief 007's launcher
gap, cross-referenced below). Slice 1's empirical result then governs
slice 2+'s shape.

---

#### Why slice this way (the stakeholder's framing)

The stakeholder's direction is explicit: too many decisions in one brief
produces re-work when the early assumptions don't hold. Slicing isolates
the assumptions that need to be tested first, and defers decisions whose
shape depends on those assumptions until the evidence is in.

For slice 1 specifically, the assumption under test is the load-bearing
one: **can the framework launch its own lead shop into a container,
using primitives that already exist, with whatever minimal new piece is
required to invoke that launch from the host?** If that assumption holds,
the broader orchestrator story is a series of additive composition steps.
If it does not — e.g., if the lead-launch path requires a primitive that
does not exist on the adopter's host (the launcher gap brief 007 names),
or if `shop-templates bootstrap --shop-type lead` exposes a gap when run
from inside a container against a mounted working tree — those findings
materially change what slice 2+ should commit to.

Pre-committing slice 2+'s shape now would risk locking in decisions
(credential model, repo-creation responsibility, BC selection,
orchestrator image pipeline) before the underlying primitives have been
proven to compose. The brief explicitly defers those decisions.

---

#### Interview notes (PO capture, scoped to slice 1)

**What behavior would satisfy the stakeholder for slice 1:**

- The adopter (or the framework's own test) does **one** thing on their
  host that brings up a lead-shop container plus postgres on the
  `shopsystem` network. The "one thing" is allowed to be a `docker
  compose up` against a compose file the framework ships, or a thin
  invocation that wraps it — slice 1 does not pre-decide the exact CLI
  shape (see "Open for slice 1's authoring shop"), but it is bounded:
  one host command, no follow-up host commands before the lead-shop
  container is ready for a Claude Code session.
- The lead-shop container, on first run, bootstraps its own working tree
  using `shop-templates bootstrap --shop-type lead --shop-name <product>`
  against a host-mounted directory. The adopter does not install Python,
  `shop-templates`, or any framework tool on their host. Those live in
  the lead-shop container's image.
- Docker-out-of-docker is NOT required for slice 1. The lead-shop
  container does not need to launch sibling containers in slice 1 (BCs
  are out of scope here). The lead-shop container does its scaffold work
  inside itself; postgres is brought up by the same compose, not by the
  lead-shop container shelling out. (Docker-out-of-docker re-enters the
  picture in slice 2+ when BC launches are added.)
- Postgres comes up via the existing compose service. The compose file
  the adopter uses references the same image / env / network the
  framework already runs.

**What would NOT satisfy the stakeholder for slice 1:**

- A "kitchen-sink" orchestrator that tries to bring up BCs, manage
  credentials, create GitHub repos, or do anything beyond lead + postgres
  in slice 1. The stakeholder correction is explicit: defer.
- A net-new composition mechanism when docker compose already exists. If
  the slice 1 author finds themselves writing a Python orchestrator that
  shells out to `docker run` for postgres rather than using the existing
  compose service, the slice has drifted; come back to PO.
- A slice 1 that commits the slice 2+ shape (image pipeline, credential
  model, BC subset semantics). Those are deferred BY DESIGN; the brief
  must not pre-resolve them.
- A slice 1 that requires the adopter to hand-scaffold the lead-shop
  working tree on their host before the container starts. The whole point
  is "bootstrap from inside the container."

**Boundaries the PO commits to, for slice 1 only:**

1. **Slice 1 scope is lead-shop container + postgres, brought up
   together via docker compose**, with the lead-shop container performing
   its own first-run scaffold via `shop-templates bootstrap --shop-type
   lead`.
2. **No BC bring-up in slice 1.** Slice 2+ adds BCs; slice 1 does not
   pre-decide the shape.
3. **Compose what exists.** The postgres service is the one already
   declared in `repos/shopsystem-devcontainer/docker-compose.yml`
   (extending / referencing it, or copying its declaration into a new
   compose file the framework ships for adopter use — slice 1's
   authoring shop picks; either way the postgres bring-up is the
   existing one, not a reinvention).
4. **Bootstrap from inside the container is non-negotiable.** The
   adopter does not run `shop-templates bootstrap` on their host. The
   lead-shop container does it.
5. **No host-side framework install.** The host needs Docker (Compose
   v2 plugin, i.e. `docker compose ...` rather than the legacy
   `docker-compose`). Nothing else.
6. **Slice 1's success criterion is empirical and observable** — see
   "Slice 1 done" below.
7. **Slice 1's findings explicitly inform slice 2+.** If slice 1 surfaces
   that the lead-launch path needs a new primitive (per brief 007's
   launcher-gap finding), that primitive's existence and shape is part
   of slice 1's deliverable evidence base, not a slice 2 commitment.

---

#### "Slice 1 done" — the observable end state

**When slice 1 is delivered, ALL of the following hold:**

- Running the documented slice 1 host command from a clean host (Docker
  installed; no other framework tooling) brings up:
  - A **postgres** container running on the `shopsystem` Docker network,
    backed by the existing `repos/shopsystem-devcontainer/docker-compose.yml`
    postgres service definition (or an equivalent composition that
    references the same image / env / network).
  - A **lead-shop container** running on the same network, with a
    host-mounted working directory that, after first-run bootstrap, is
    a valid scaffolded lead-shop tree (the same shape `shop-templates
    bootstrap --shop-type lead --shop-name <product>` produces today).
- The lead-shop container is reachable for the adopter to attach a
  Claude Code session against (via `docker exec`, attach, or the
  equivalent — the exact attach shape is the slice 1 authoring shop's
  call, but the affordance must exist and be documented).
- The lead-shop container can reach postgres on the `shopsystem`
  network (smoke test: a `shop-msg`-equivalent reachability check from
  inside the lead-shop container succeeds, OR the slice 1 deliverable
  includes an equivalent observable that demonstrates network
  connectivity).
- The slice 1 deliverable **includes an honest finding** about whether a
  new host-side primitive was required to invoke the lead-shop
  container's launch. (Brief 007's launcher-gap finding predicts one will
  be needed. The slice 1 deliverable confirms or refutes that prediction
  empirically.) The finding does not have to *resolve* the launcher
  question — that's brief 007's open Q7 — but it must surface the
  evidence.

**What "slice 1 done" explicitly does NOT include:**

- BC containers running.
- A messaging registry populated with the adopter's BCs.
- The adopter's GitHub repos created.
- A credential model for talking to GitHub or private registries.
- A pinned image pipeline (which image, which registry, which tag
  convention).
- An "orchestrator BC" decided as the home.
- Idempotent re-run semantics for the full orchestrator (slice 1
  idempotency is scoped to "re-running slice 1's compose against an
  existing state does not corrupt; either skips or refuses cleanly").

All of those are deferred to slice 2+, after slice 1's evidence is in.

---

#### What slice 1 must NOT do

The list of "must NOT do in v1" from the prior brief shape is collapsed
into the single principle that defines this slice: **slice 1 commits the
lead-only prove-out and nothing else.** Specifically, slice 1 must NOT:

1. **Bring up BCs.** That is slice 2+.
2. **Create the adopter's GitHub repos.** Deferred to a later slice;
   not pre-decided.
3. **Implement a credential model.** Deferred.
4. **Decide the orchestrator's owning BC.** Slice 1's lead-launch piece
   has its own ownership question (Architect at dispatch); the full
   orchestrator's BC home is deferred.
5. **Decide the orchestrator image pipeline.** Slice 1 may need a thin
   image to host the lead-shop's scaffold-on-startup behavior, but slice
   1 picks the minimum that works (e.g., extending the existing
   devcontainer image, or composing against it) and explicitly leaves
   the "what is the long-term image" question to slice 2+.
6. **Re-implement primitives that exist.** `shop-templates bootstrap` is
   called, not re-implemented. Docker compose is used, not replaced.
7. **Commit slice 2+'s shape.** Even if the slice 1 author has a clear
   intuition about how BCs should be added next, that intuition is
   evidence for the slice-2 brief authoring conversation, not a
   commitment in this brief.

---

#### Empirical pre-state evidence

Captured in this session, slice 1-relevant only. (The prior brief's full
substrate enumeration is preserved by reference into brief 007's
empirical-pre-state section, which the slice 2+ authors will revisit.)

##### Docker compose is already used by the framework

[`repos/shopsystem-devcontainer/docker-compose.yml`](../repos/shopsystem-devcontainer/docker-compose.yml)
declares the postgres service:

```yaml
services:
  postgres:
    image: postgres:16
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: shopsystem
    networks:
      - shopsystem

networks:
  shopsystem:
    attachable: true
```

Slice 1 extends or composes against this — it does not introduce a new
composition primitive. The stakeholder's correction calls this out
directly ("docker compose exists already, so use that").

##### `shop-templates bootstrap --shop-type lead` is the lead scaffold today

[`repos/shopsystem-templates/src/shop_templates/cli.py`](../repos/shopsystem-templates/src/shop_templates/cli.py)
exposes `shop-templates bootstrap --shop-type lead --shop-name <product>
--target <dir>` as the in-place scaffold for a lead-shop working tree.
Slice 1's "bootstrap from inside the container" path invokes this
command against a mounted target directory.

##### The launcher gap (brief 007 cross-reference)

Brief 007's launcher-gap finding (added in the same correction round
that narrowed this brief) names the asymmetry: `bc-container launch`
([CLI](../repos/shopsystem-bc-launcher/src/bc_launcher/cli.py)) is the
canonical per-container launch primitive for **BCs** only — it takes
a `bc_name` positional and a `--repo-url`, and assumes the launched
shop is a BC. There is no analogous host-side primitive that launches
a **lead shop** into a container. Slice 1 is the empirical proving
ground for that gap: launching the lead-shop container from a clean
host with no framework tools requires either docker compose alone
(if a compose file is the entire surface), or a small new wrapper
that brief 007's open Q7 will resolve into either "extend
`bc-launcher` to handle `--shop-type {bc,lead}`" or "introduce a new
`lead-launcher` BC."

Slice 1 does NOT pre-decide that question; it produces evidence for it.

##### Docker-out-of-docker is NOT needed for slice 1

The prior brief's docker-out-of-docker substrate evidence (devcontainer
docker socket bind-mount, `docker ps` works inside the devcontainer)
remains true and is relevant to slice 2+. For slice 1 it is **not
required**, because slice 1 does not launch sibling containers from
inside the lead-shop container — the lead-shop container does its own
scaffold work in-process, and postgres is brought up by the same
compose, not by the lead-shop container shelling out.

This is itself part of slice 1's value: by deferring the BC-launch piece
(and therefore the in-container docker-out-of-docker step), slice 1
isolates the lead-bootstrap assumptions from the orchestrator's
container-launching-container assumptions, so each can be tested
independently.

---

#### Open for slice 1's authoring shop (Architect's call at dispatch)

Slice 1 has its own narrow set of decisions that the Architect resolves
at dispatch time. These are NOT the deferred slice 2+ questions; they
are the resolutions slice 1 itself needs to land:

- **Compose file shape and home.** Does slice 1 ship a new compose file
  (e.g., `shopsystem-lead-bootstrap/docker-compose.yml`), extend the
  existing devcontainer compose, or expose a `shop-templates`-published
  starter compose? Architect's call. The PO commits only that the
  postgres bring-up references the existing service definition rather
  than reinventing it.
- **Lead-shop container image.** Slice 1 needs an image whose entrypoint
  (or compose `command:`) runs `shop-templates bootstrap --shop-type
  lead` against a mounted directory. Whether that image is the existing
  devcontainer image with a startup script, a thin new image built on
  top, or `shop-templates`-provided is the Architect's call. The PO
  commits only that the adopter does not have to install `shop-templates`
  on their host.
- **First-run idempotency for slice 1.** If the mounted directory
  already contains a scaffolded lead-shop tree, what does the entrypoint
  do? Skip, refuse, or overwrite with a `--force` opt-in. Architect's
  call; PO lean is "skip with a clear log line; never silently overwrite."
- **The host-side invocation shape.** Whether the adopter runs `docker
  compose -f <path> up` directly, or whether there's a thin
  `shopsystem-bootstrap` wrapper, is the Architect's call subject to
  brief 007's open Q7 (the launcher-gap question). The PO commits only
  that the host invocation is bounded to one command and requires no
  framework tooling on the host.
- **Slice 1's owning BC.** Candidates: `shopsystem-templates` (since
  slice 1's heaviest work is calling `shop-templates bootstrap`),
  `shopsystem-bc-launcher` (since the launcher-gap resolution may move
  this here), `shopsystem-devcontainer` (since the compose file lives
  there today). Architect-resolved at dispatch; ADR-shaped if the
  decision is non-obvious. The PO observation (non-binding): slice 1's
  ownership is naturally coupled with brief 007's open Q7 resolution —
  if Q7 lands on "extend `bc-launcher`," `shopsystem-bc-launcher` is
  the natural slice 1 home; if Q7 lands on "new `lead-launcher` BC,"
  slice 1 may seed that BC.

---

#### Future slices — sketched, NOT committed

These are enumerated so the slice 1 author and the Architect see where
the brief is heading, but **the brief does NOT commit any of these.**
Their shape is intentionally left to be re-decided once slice 1's
evidence is in. Pre-resolving them now is exactly the failure mode the
stakeholder's correction is preventing.

- **Slice 2 (sketch):** add BC bring-up. Once slice 1 demonstrates a
  working lead-in-a-container, slice 2 explores adding a single BC
  container (likely `shopsystem-messaging`, since `shop-msg` is
  non-functional without it) launched from inside the lead-shop
  container via the existing `bc-container launch` primitive. This is
  where docker-out-of-docker re-enters the picture. Slice 2's shape
  depends on slice 1's findings about the lead-launch path.
- **Slice 3 (sketch):** add the full BC set per the adopter's manifest.
  Once slice 2 proves the one-BC bring-up path, slice 3 extends to all
  BCs declared in a manifest (per brief 005). The "all declared vs
  subset" question (formerly Q6 in this brief) is re-opened here, not
  pre-decided.
- **Slice 4 (sketch):** credential and repo-creation surface. Once the
  bring-up flow is proven end-to-end, the credential model (formerly Q1)
  and the GitHub repo creation responsibility (formerly Q2) become
  worth committing to. By that point, the empirical evidence from
  slices 1–3 will materially shape the answer (e.g., what credentials
  the orchestrator *actually* needs in practice).

**Each future slice is its own brief, authored after the prior slice's
evidence is in.** This brief does NOT package them. The brief explicitly
defers each one until the slice before it has landed and its assumptions
have been tested.

---

#### Cross-brief coherence with brief 007

Brief 007 (the doc track) and this brief (the capability track) are
siblings. The narrowing of this brief to slice 1 has these concrete
implications for cross-brief coherence:

- **Brief 007's v1 manual-composition walkthrough remains the adopter's
  story until slice 1 lands.** Brief 007 already commits this — its v1
  doc walks the adopter through the manual composition (postgres
  compose, `shop-templates bootstrap`, per-BC `bc-container launch`,
  manual `gh repo create`) and updates to describe the orchestrator
  *if and when* the orchestrator lands. With this brief narrowed to
  slice 1, brief 007's doc updates only to describe the lead-only
  prove-out when slice 1 lands; the manual composition for BCs remains
  in the doc until slice 2+ delivers BC bring-up.
- **Brief 007's launcher-gap finding (open Q7) points at slice 1 as its
  empirical answer source.** Brief 007 surfaces the gap; slice 1
  produces the evidence; whoever authors the Q7 resolution (Architect
  + PO together, likely with a PDR) consumes slice 1's findings as
  input. The two briefs are intentionally tied here.
- **The slice 1 ↔ Q7 coupling is the most important cross-brief
  detail.** If brief 007's Q7 lands on "extend `bc-launcher` to
  `--shop-type {bc,lead}`," slice 1's lead-launch wrapper is the
  vehicle. If Q7 lands on "new `lead-launcher` BC," slice 1 may seed
  that BC. The brief does NOT pre-decide; it commits the empirical
  prove-out and trusts the evidence to inform Q7.

---

#### Sequencing

- **Slice 1 is dispatched as its own scope item.** The brief is ready
  for the Architect's discriminator pass on slice 1 only.
- **Slice 2+ briefs are authored AFTER slice 1's evidence is in.** They
  are not bundled into this brief and they are not pre-resolved.
- **Brief 004, 005, 006 remain relevant in spirit but not as slice 1
  blockers.** Slice 1 does not consume the BC manifest (brief 005) or
  the registry sync (brief 006) because it does not bring up BCs.
  Slices 2+ will.
- **Brief 007 is a sibling, not a dependency, and vice versa.** Either
  brief can advance. Brief 007's open Q7 (launcher gap) is the named
  follow-up that slice 1's evidence informs.

---

#### Out of scope for this brief — named explicitly

Everything that was committed by the prior brief shape and is NOT in
slice 1 is explicitly OUT of scope here. Listing them so the slice 1
author cannot accidentally pull them in, and so the slice 2+ authors
know what's still on the table:

- **BC containers running** — slice 2+.
- **Credential model (formerly Q1)** — slice 4 (sketch).
- **GitHub repo creation responsibility (formerly Q2)** — slice 4
  (sketch).
- **Orchestrator's full BC home (formerly Q3)** — re-decided once the
  full orchestrator's scope is concrete (slice 2+).
- **Orchestrator image pipeline (formerly Q4)** — slice 2+ at earliest;
  slice 1 picks the minimum that works for lead-only.
- **All-declared-BCs vs subset (formerly Q6)** — slice 3 (sketch).
- **Lifecycle management** (stop, restart, credential-rotate) — not in
  any sketched slice; would be a separate brief if it surfaces.
- **Multi-product orchestration on a single host** — not in any
  sketched slice.

---

#### Grounding artifacts

- [`briefs/007-end-user-adoption-documentation.md`](007-end-user-adoption-documentation.md)
  — sibling brief, the doc track; its launcher-gap finding (open Q7)
  pairs directly with slice 1.
- [`repos/shopsystem-devcontainer/docker-compose.yml`](../repos/shopsystem-devcontainer/docker-compose.yml)
  — the existing postgres compose service; the slice 1 commitment is to
  compose against this, not reinvent it.
- [`repos/shopsystem-templates/src/shop_templates/cli.py`](../repos/shopsystem-templates/src/shop_templates/cli.py)
  — `shop-templates bootstrap --shop-type lead --shop-name <product>`
  is the in-container scaffold step.
- [`repos/shopsystem-bc-launcher/src/bc_launcher/cli.py`](../repos/shopsystem-bc-launcher/src/bc_launcher/cli.py)
  — current `bc-container` surface; today launches BCs only (no
  `--shop-type` flag, no lead-launch path). The launcher-gap finding in
  brief 007 is grounded here.
- [`briefs/002-shop-bootstrap-cli-surface.md`](002-shop-bootstrap-cli-surface.md)
  — per-shop bootstrap CLI surface; slice 1 invokes this in-container.
- [`adr/004-bc-launcher-as-new-bc.md`](../adr/004-bc-launcher-as-new-bc.md)
  — precedent for "new BC vs extend existing" that brief 007's open Q7
  raises again.
- [`pdr/004-bc-container-command-ownership.md`](../pdr/004-bc-container-command-ownership.md)
  — same precedent at the PDR level.

(Slice 2+ will pull back in briefs 004, 005, 006 and additional
grounding artifacts. They are intentionally excluded from this slice 1
brief's grounding to keep the slice's surface small.)

---

#### What this leaves open

The brief commits **slice 1 intent**, not slice 2+ intent and not
slice 1 scenarios.

- Slice 1's narrow Architect-resolved details (compose file shape and
  home; lead-shop container image; first-run idempotency; host-side
  invocation shape; slice 1's owning BC) — see "Open for slice 1's
  authoring shop" above. These resolve at dispatch.
- Brief 007's open Q7 (launcher gap) — paired with slice 1; slice 1
  produces empirical evidence to inform Q7, but the resolution lives
  in brief 007 (or its own PDR), not here.
- Every deferred slice 2+ decision — explicitly listed under "Future
  slices" and "Out of scope" above. None of those is committed here.

The PO commits the slice. The Architect resolves slice 1's dispatch
details and produces the evidence. The slice 2+ briefs are authored
later, on the evidence, by whoever holds the PO seat then.

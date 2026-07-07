---
id: ADR-022
kind: adr
title: "`bc-base` rebuilds are CENTRALIZED in `shopsystem-bc-launcher` (version-bump-then-rebuild), not fan-in `repository_dispatch` from each utility repo"
status: accepted
date: "2026-06-09"
description: "`bc-base` rebuilds are CENTRALIZED in `shopsystem-bc-launcher` (version-bump-then-rebuild), not fan-in `repository_dispatch` from each utility repo"
beads: [lead-9ja4, lead-9pbc, lead-aj5f, lead-architect, lead-c2kp, lead-czwo, lead-held, lead-pw41, lead-tycv, lead-xq0]
edges:
  supersedes: [ADR-021]
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: [ADR-018]
  pins: []
  related: []
---
# ADR-022 — `bc-base` rebuilds are CENTRALIZED in `shopsystem-bc-launcher` (version-bump-then-rebuild), not fan-in `repository_dispatch` from each utility repo

**Status:** accepted (2026-06-09)
**Authors:** dstengle, Claude (lead-architect)
**Acceptance note (2026-06-09):** ratified by dave. The centralized
version-bump-then-rebuild path was demonstrated empirically: bc-launcher
`v0.2.1` (bump `pyproject` → tag `v*` → `publish-bc-base.yml` rebuilds +
republishes `bc-base:latest`/`:v0.2.1`) — no fan-in `repository_dispatch`.
This retires the trigger contract of scenarios 38/40 and supersedes the
40-family beads (lead-tycv/usc7/wq0p/1j1h); `lead-czwo` (scheduled
poll/pin-bump) is the live successor for *automatic* propagation.
**Supersedes the trigger mechanism of:** [ADR-021 §D2](021-bc-base-image-owned-by-bc-launcher-auto-rebuilds-on-utility-release.md)
— the cross-repo `repository_dispatch` fan-in (each utility release emits a
`repository_dispatch` to bc-launcher, which rebuilds against "the current
utility versions"). ADR-021's D1 (ownership: Dockerfile + publish CI live in
bc-launcher), D3 (launch pulls `:latest`), and D4 (deferred controlled/pinned
releases; rollback-by-republish) **stand unchanged**.
**Pins (the contract surface this rests on):**
[scenario 36](../features/bc-launcher/36-bc-base-dockerfile-co-located-in-bc-launcher-repo.gherkin)
(Dockerfile co-located in bc-launcher — the build authority this ADR keeps
single) and [scenario 37](../features/bc-launcher/37-bc-base-published-to-ghcr-on-version-tag-public.gherkin)
(publish-on-version-tag to ghcr, version + `latest`, public — the publish path
this ADR keeps). This ADR **retires the trigger contract** of
[scenario 38](../features/bc-launcher/38-bc-base-build-workflow-rebuilds-on-repository-dispatch.gherkin)
(rebuild-on-inbound-`repository_dispatch`) and
[scenario 40](../features/bc-launcher/40-utility-release-emits-repository-dispatch-to-bc-launcher.gherkin)
(each utility release emits a `repository_dispatch` to bc-launcher) — see the
@scenario_hash enumeration in the pre-state findings: neither is yet
hash-pinned or dispatched, so this is a feature-text supersession, not a
BC-side retirement.
**Anchored to:** [ADR-018](018-empirical-verification-is-contract-surface.md)
(the artifact-surface evidence rule the pre-state findings honor — every
finding below is from ghcr/GitHub artifact surface and the lead-held
`features/`, no `repos/` BC source).
**Related beads:** `lead-c2kp` (the bc-base ownership/rebuild-trigger feature
this ADR re-scopes), `lead-9pbc` (CLOSED — the `BC_LAUNCHER_DISPATCH_TOKEN`
empty/401 blocker the fan-in design produced; this ADR removes the token from
steady state), `lead-9ja4` (the wrong-repo-pin finding this ADR generalizes —
see finding 2), `lead-aj5f` (CLOSED — bc-launcher is now public, simplifying
credentials), `lead-pw41` / `lead-xq0` (the fix-landed-but-not-live drift class
this whole bc-base line addresses).

---

## Context

ADR-021 settled that `shopsystem-bc-launcher` **owns** the `shopsystem-bc-base`
image (Dockerfile + publish CI co-located, D1) and that the image
**auto-propagates** on a framework-utility release (D2), with launch pulling
`:latest` (D3) and controlled/pinned releases deferred (D4). For the
auto-propagation *trigger*, ADR-021 chose a **cross-repo `repository_dispatch`
fan-in**: every utility repo's release workflow emits a `repository_dispatch`
to bc-launcher, and bc-launcher rebuilds bc-base "against the current utility
versions."

Building that out surfaced two problems the fan-in design cannot resolve
cleanly, both now empirically confirmed on the artifact surface (findings
below):

1. **Token sprawl, and it already blocked us.** A cross-repo
   `repository_dispatch` cannot use the default `GITHUB_TOKEN` (scoped to the
   emitting repo); it needs a `BC_LAUNCHER_DISPATCH_TOKEN` PAT configured as a
   secret **in every utility repo**. Cutting `shopsystem-templates@v0.2.0`
   (lead-68db) fired the emit step with an empty secret → HTTP 401, the
   dispatch was never delivered, and the rebuild never ran (`lead-9pbc`). Every
   new utility repo re-incurs this secret-provisioning cost.

2. **The image bakes MULTIPLE deps, so a per-utility emit is the wrong shape.**
   "Rebuild against the current utility versions" is under-specified when the
   versions live as **immutable `@vMAJOR.MINOR.PATCH` pins inside the
   Dockerfile** (finding 1). A bare rebuild re-pins the same versions and
   changes nothing. The real operation on a utility release is **bump the
   Dockerfile pin, THEN rebuild** — and that bump logic belongs where the
   Dockerfile lives (bc-launcher), not smeared across N emitting repos.

The user has settled the re-scope (this ADR records it, does not re-open it):
**bc-base rebuilds are CENTRALIZED in bc-launcher.** bc-launcher — which owns
the image — runs **one** scheduled workflow that, for each baked dependency,
checks the dep's latest release, bumps the bc-base Dockerfile version pins, and
rebuilds + republishes `:latest` if anything changed. It reads dep releases
with its **own `GITHUB_TOKEN`** (all four canonical repos are public, finding
3) — **no cross-repo `BC_LAUNCHER_DISPATCH_TOKEN`** in steady state.

This is a mechanism/operations decision with no product-UX change — an **ADR**,
not a PDR.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

Verified from the lead CWD against the ghcr/GitHub artifact surface and the
lead-held `features/` only — no BC implementation read, run, or git-observed;
the lead host carries no `repos/` BC source.

1. **What's baked today (`docker/bc-base/Dockerfile` on
   `shopsystem-bc-launcher@main`, fetched via `gh api .../contents`).** The
   image is `FROM mcr.microsoft.com/devcontainers/python:3.11` and pip-installs
   **three** framework deps in the `<utility> @ git+https://...@vX.Y.Z` shape:
   - `shop-msg @ git+https://github.com/dstengle/shop-msg.git@v0.3.0`
   - `beads @ git+https://github.com/dstengle/beads.git@v0.5.1`
   - `shop-templates @ git+https://github.com/dstengle/shopsystem-templates.git@v0.2.0`

   **`scenarios` is NOT baked.** This is a real gap: BCs use the `scenarios`
   CLI (Gherkin hash/verify — the same CLI the lead uses for hash discipline),
   so a launched BC has no `scenarios` on PATH from the base image. The
   centralized poll's watched-repo list must **add `shopsystem-scenarios`** so
   the bumped Dockerfile bakes it. **Confirmed** (Dockerfile installs only the
   three above).

2. **Wrong-repo-pin generalization — the bug class is BROADER than
   `lead-9ja4` recorded, and bc-base is currently UN-REBUILDABLE.** `lead-9ja4`
   asserted the convention `github.com/dstengle/<utility>` holds for everything
   *except* templates (`shop-msg -> dstengle/shop-msg`,
   `beads -> dstengle/beads` "match"). **That premise is empirically false.**
   Probing each pinned URL (`curl` of `github.com/dstengle/<name>`) and
   `gh api repos/dstengle/<name>`:

   | Dockerfile pin URL | repo exists? | real repo | tag exists? |
   | ------------------ | ------------ | --------- | ----------- |
   | `dstengle/shop-msg@v0.3.0` | **404 — MISSING** | `dstengle/shopsystem-messaging` | even there only `v0.1.0` exists, **not `v0.3.0`** |
   | `dstengle/beads@v0.5.1` | **404 — MISSING** | none (`beads` is an external/upstream tool, no `dstengle/beads*` repo) | n/a |
   | `dstengle/shopsystem-templates@v0.2.0` | 200 — OK | (itself) | `v0.2.0` exists — OK |

   So **two of three baked pins reference nonexistent repos**, and the one
   correct repo is pinned to a **nonexistent tag** (`shopsystem-messaging` has
   only `v0.1.0`). **The current `docker/bc-base/Dockerfile` cannot build** —
   any `pip install` of the `shop-msg`/`beads` lines 404s. This is the same bug
   class as lead-9ja4/lead-dlrx (templates), now confirmed to also hit
   `shop-msg` and `beads`. **This determines the correct watch-list the
   centralized poll must use** (see Decision D2). **Confirmed.**

3. **Repo identities + visibility (the watch-list source of truth).**
   `gh repo list dstengle` + per-repo `gh api`:
   - `dstengle/shopsystem-messaging` (public) — owns `shop-msg`; tags: `v0.1.0`.
   - `dstengle/shopsystem-scenarios` (public) — owns `scenarios`; tags: `v0.1.0`.
   - `dstengle/shopsystem-templates` (public) — owns `shop-templates`; tags:
     `v0.2.0`, `v0.1.0`.
   - `dstengle/shopsystem-bc-launcher` (**public** — `lead-aj5f` resolved to
     option (a)).
   - `dstengle/shop-msg`, `dstengle/beads`, `dstengle/scenarios`,
     `dstengle/shop-templates` — **all 404 (do not exist).**
   Because every canonical repo is **public**, bc-launcher's own
   `GITHUB_TOKEN` can read all their releases — **no cross-repo PAT needed**.
   **Confirmed.**

4. **The fan-in trigger wiring to retire EXISTS in all three utility repos.**
   Each utility's `release.yml` (fetched via `gh api .../contents`) carries a
   `repository_dispatch`-to-bc-launcher emit on a `v*` tag push, using
   `secrets.BC_LAUNCHER_DISPATCH_TOKEN`:
   - `shopsystem-templates/.github/workflows/release.yml` — job
     `dispatch-bc-launcher`, `event_type: shopsystem-templates-released`.
   - `shopsystem-messaging/.github/workflows/release.yml` — job
     `dispatch-bc-launcher-build`.
   - `shopsystem-scenarios/.github/workflows/release.yml` — job
     `notify-bc-launcher`.
   On the BUILD side, bc-launcher's
   `.github/workflows/rebuild-bc-base.yml` is `on: repository_dispatch` (types:
   `rebuild-bc-base`) and **does a bare `docker build` with `no-cache: true` —
   it does NOT bump any version pin** (it rebuilds the same pinned Dockerfile).
   This empirically confirms finding-2's "bare rebuild changes nothing"
   argument. **Confirmed.**

5. **No one-off manual rebuild is possible with the current workflows without
   code or an API call.** `rebuild-bc-base.yml` is `on: repository_dispatch`
   **only** — it has **no `workflow_dispatch` trigger**, so it does not appear
   as a "Run workflow" button and `gh workflow run` cannot start it. The only
   ways to fire it today are (a) a utility release emitting the dispatch (which
   `lead-9pbc` showed is broken on the empty token), or (b) a direct
   `gh api repos/dstengle/shopsystem-bc-launcher/dispatches -f event_type=rebuild-bc-base`
   from a credential with dispatch scope. `publish-bc-base.yml` is `on: push
   tags v*` only (also no `workflow_dispatch`). **A `workflow_dispatch` trigger
   is a cheap, valuable add** the centralized design should carry so an
   operator can force a rebuild from the Actions UI. **Confirmed.**

6. **@scenario_hash enumeration over the lead-held `features/` (the
   message-type / retirement pre-state step).** `grep -rn "@scenario_hash"
   features/bc-launcher/` returns exactly **one** pinned hash:
   - `features/bc-launcher/42-…-installs-shop-templates-in-vcs-pin-shape.gherkin`
     → `@scenario_hash:ccb145d71c7100a2`.
   Scenarios **36–41 and 43** are lead-authored (ADR-021's outputs) but **not
   yet hash-pinned and not yet dispatched** — there is no BC-side pinned
   `@scenario_hash` for the `repository_dispatch` trigger (38) or the
   utility-emit (40) this ADR supersedes. **Therefore this supersession is a
   feature-text / ADR-level retirement, not a retirement of BC-side pinned
   coverage** — no conflicting BC `@scenario_hash` set to enumerate for
   dispatch beyond `ccb145d71c7100a2`, which (templates-only baking) is itself
   re-scoped by D2 below. **Confirmed.**

### What could NOT be verified (asserted, not confirmed)

- **Whether `shop-msg`/`beads` ever installed from those 404 URLs.** The
  Dockerfile pins are dead now; whether bc-base was ever successfully built
  from this exact Dockerfile (vs. an earlier different one) is build-history,
  off the lead artifact surface. The relevant present fact — *the current pins
  404* — is confirmed; the history is not needed.
- **The bc-base image's currently-published `:latest` digest contents.** What
  CLIs the live `ghcr.io/dstengle/shopsystem-bc-base:latest` carries is a
  registry-blob fact, not read here; the local `Dockerfile.bc-base-rebuild`
  breadcrumb (an interim host-side re-pin layering messaging `ff024c8`) shows
  the live image predates current messaging and was being patched ad hoc — the
  exact drift this centralized rebuild closes.

---

## Decision

### D1 — Ownership and publish path are unchanged from ADR-021

The Dockerfile (`docker/bc-base/Dockerfile`) and publish CI stay in
`shopsystem-bc-launcher`; publish remains on a `v*` tag push to
`ghcr.io/dstengle/shopsystem-bc-base` with version + `latest`, public
(`publish-bc-base.yml`, scenario 37). This ADR changes only the **rebuild
trigger**, not ownership or publish.

### D2 — Rebuild is CENTRALIZED: one scheduled bc-launcher workflow bumps pins then rebuilds

bc-launcher carries a **single scheduled workflow** (e.g. `on: schedule`, plus
`on: workflow_dispatch` per finding 5) that, **for each baked dependency**:

1. resolves the dependency's **latest release tag** from its canonical repo,
   read with bc-launcher's **own `GITHUB_TOKEN`** (all repos public, finding 3);
2. **bumps the `@vMAJOR.MINOR.PATCH` pin** in `docker/bc-base/Dockerfile` if the
   latest tag differs from the baked pin;
3. if **any** pin changed, **rebuilds bc-base and republishes `:latest`** at the
   new digest (and commits the bumped Dockerfile, so the pins stay
   content-addressable per scenario 37's reproducibility property).

The **watched-dependency list**, corrected against finding 2 + finding 3 (this
is the load-bearing output of the pre-state work):

| baked CLI | canonical repo (correct) | current Dockerfile pin | correct pin shape |
| --------- | ------------------------ | ---------------------- | ----------------- |
| `shop-msg` | `dstengle/shopsystem-messaging` | `dstengle/shop-msg@v0.3.0` **(404)** | `…/shopsystem-messaging.git@<latest>` (today `v0.1.0`) |
| `shop-templates` | `dstengle/shopsystem-templates` | `dstengle/shopsystem-templates@v0.2.0` (OK) | unchanged shape |
| `scenarios` | `dstengle/shopsystem-scenarios` | **NOT baked** | **ADD** `…/shopsystem-scenarios.git@<latest>` |
| `bd` (beads) | external/upstream (no `dstengle/beads*`) | `dstengle/beads@v0.5.1` **(404)** | re-point to beads' real upstream/published source |

The pin-correction (the 404 repos) and the `scenarios` add are **part of the
same work** as wiring the centralized rebuild — the rebuild logic is moot until
the Dockerfile pins resolve.

**Immutable-pin consequence (the load-bearing mechanic):** because pins are
immutable `@vX.Y.Z`, "rebuild on update" is necessarily "**bump the pin THEN
rebuild**" — a bare `docker build` (what `rebuild-bc-base.yml` does today,
finding 4) re-pins the same versions and produces no change. The workflow MUST
mutate the Dockerfile, not just re-run the build.

### D3 — Steady state needs NO cross-repo `BC_LAUNCHER_DISPATCH_TOKEN`

The poll runs inside bc-launcher reading **public** dep repos with the default
`GITHUB_TOKEN`. The `BC_LAUNCHER_DISPATCH_TOKEN` PAT — and the per-utility
secret provisioning that produced the `lead-9pbc` 401 — is **removed from
steady state**. (A token is only ever needed if a watched dep repo becomes
private, which is not the case today.)

### D4 — A `workflow_dispatch` trigger is added for operator-forced rebuilds

The centralized workflow (and/or `rebuild-bc-base.yml`) gains a
`workflow_dispatch` trigger so an operator can force a check-bump-rebuild from
the Actions UI / `gh workflow run` without a code change or a raw
`gh api .../dispatches` call (closing the finding-5 gap).

### D5 — Launch-pull (ADR-021 D3) and deferred controlled-release (ADR-021 D4) are unchanged

D3 (launch resolves current `:latest` digest, scenario 39) and D4
(controlled/pinned propagation deferred; rollback-by-republish-prior-digest,
scenario 41) carry over verbatim. A scheduled poll reintroduces *some*
propagation latency vs. event-driven dispatch; this is accepted as the cost of
removing token sprawl, and is bounded by the schedule interval plus the
`workflow_dispatch` escape hatch (D4) for urgent fixes.

---

## Cross-BC ownership / decomposition (re-scoped plan)

All of this is **`shopsystem-bc-launcher`** work — centralizing collapses the
prior two-sided (BUILD + per-utility trigger-EMIT) split into one repo. The PO
authors the scenarios after this ADR; the Architect picks the vehicle at
dispatch time against the discriminator.

- **`shopsystem-bc-launcher`** (`assign_scenarios` — new capability the contract
  surface does not pin; per the discriminator, the centralized poll/bump and the
  `workflow_dispatch` trigger are new behavior):
  1. **Correct the Dockerfile pins** (`shop-msg` → `shopsystem-messaging`,
     `beads` → real upstream, latest valid tags) and **add `scenarios`
     (`shopsystem-scenarios`)** — finding 1 + finding 2.
  2. **The centralized scheduled workflow** (D2): per-dep latest-release lookup,
     Dockerfile pin-bump, conditional rebuild + republish `:latest`, commit the
     bump.
  3. **The `workflow_dispatch` trigger** (D4).
  4. **Retire** `rebuild-bc-base.yml`'s `on: repository_dispatch` trigger (no
     longer fed) — scenario 38's trigger contract is dropped.
- **`shopsystem-messaging`, `shopsystem-scenarios`, `shopsystem-templates`**
  (cleanup — likely `request_maintenance`, flat removal of the now-dead emit
  job): **delete the `dispatch-bc-launcher*` job** from each `release.yml` and
  **decommission the `BC_LAUNCHER_DISPATCH_TOKEN` secret** — scenario 40's
  emit contract is dropped. The Architect confirms maintenance-vs-bugfix at
  dispatch time (it is flat workflow-file deletion with no new scenario, so
  `request_maintenance` is the likely vehicle).

**Scenario reconciliation.** Per finding 6 the only hash-pinned bc-base
scenario is `42` (`ccb145d71c7100a2`, templates-only baking); D2 generalizes it
to the corrected multi-dep set, so its successor scenario supersedes it.
Scenarios 38 and 40 are not yet pinned/dispatched — their retirement is a
lead-side feature-text edit, not a BC `@scenario_hash` retirement.

---

## Alternatives considered

**Option A — Keep the ADR-021 fan-in `repository_dispatch` (the status quo
being superseded).** Rejected: (1) token sprawl — every utility repo needs the
`BC_LAUNCHER_DISPATCH_TOKEN` PAT, which already failed open (`lead-9pbc`, 401 on
empty secret); (2) a per-utility emit + bare rebuild does not bump immutable
pins, so it rebuilds the same versions and propagates nothing (finding 4); (3)
build/version-bump logic is split across N repos instead of living with the
Dockerfile. Event-driven *promptness* is its only advantage, recovered partly
by D4's `workflow_dispatch`.

**Option B — Single-source (templates-only) trigger.** This is effectively
what scenario 42 (templates-only baking) plus a templates-only dispatch would
give. Rejected: the image bakes **multiple** deps (shop-msg, scenarios, beads,
shop-templates — finding 1/2), so a templates-only trigger misses
messaging/scenarios/beads releases entirely. Incompleteness is the core defect.

**Option C — Pin-bump PR automation (Dependabot-style) against bc-launcher.**
A bot opens a PR bumping each pin on a dep release; merge fires the same-repo
build. Rejected for the auto-propagate posture (matches ADR-021's Option B
rejection): it inserts a human merge between release and propagation — that is
precisely the *controlled/pinned* model ADR-021 D4 defers. It is the natural
realization of that deferred work, named there, not adopted now. (D2's
scheduled bump can *commit* directly without a gating PR, preserving
auto-propagate.)

**Option D — Each BC builds its own image.** Rejected as in ADR-021 Option D:
bc-launcher runs all BCs from one base image; fragmenting multiplies the
rebuild surface this ADR is trying to make single.

---

## Consequences

- **bc-base is currently un-rebuildable and this is now the gating fact**
  (finding 2): two of three pins 404, the third pins a nonexistent tag. The
  pin-correction + `scenarios` add (D2 item 1) must land **before** the
  centralized rebuild has anything valid to build — it is the first scenario in
  the bc-launcher `assign_scenarios`, not a follow-up.
- **Token sprawl removed** (D3): `BC_LAUNCHER_DISPATCH_TOKEN` leaves steady
  state; `lead-9pbc`'s 401 class is structurally closed (no cross-repo dispatch
  to authenticate). The secret and the three emit jobs (finding 4) are
  decommissioned as cleanup.
- **`lead-9ja4` is generalized, not just resolved for templates:** the
  wrong-repo-pin bug class hits `shop-msg` and `beads` too (finding 2);
  `lead-9ja4`'s stated premise that those "match" is false and should be
  corrected on that bead. The correct dep→repo mapping (D2 table) is the
  authoritative watch-list.
- **ADR-021 D2 (and scenarios 38, 40) is superseded;** D1, D3 (scenario 37,
  39), D4 (scenario 41) stand. The lead-held feature text for 38/40 should be
  retired/re-authored by the PO (no BC `@scenario_hash` retirement needed,
  finding 6); scenario 42 is generalized to the corrected multi-dep baking set.
- **A `workflow_dispatch` escape hatch** (D4) makes one-off operator rebuilds
  possible from the Actions UI — not possible today (finding 5).
- **Propagation latency** is reintroduced vs. event-driven dispatch (bounded by
  schedule interval + the `workflow_dispatch` override) — the accepted cost of
  removing token sprawl. The interim host-side `Dockerfile.bc-base-rebuild`
  breadcrumb (ad-hoc re-pin of messaging) is retired once the centralized
  rebuild produces a current `:latest`.

---

## Cross-references

- [ADR-021](021-bc-base-image-owned-by-bc-launcher-auto-rebuilds-on-utility-release.md)
  — ownership (D1), launch-pull (D3), deferred-controlled-release (D4) carry
  over; its D2 `repository_dispatch` trigger is what this ADR supersedes.
- [ADR-018](018-empirical-verification-is-contract-surface.md) — the
  artifact-surface evidence rule the pre-state findings honor.
- `features/bc-launcher/36,37,39,41` — the ADR-021 scenarios this ADR keeps.
- `features/bc-launcher/38,40` — the trigger scenarios this ADR retires
  (not yet hash-pinned, finding 6).
- `features/bc-launcher/42-…-installs-shop-templates-in-vcs-pin-shape.gherkin`
  (`@scenario_hash:ccb145d71c7100a2`) — templates-only baking, generalized to
  the corrected multi-dep set by D2.
- [lead-c2kp](beads:lead-c2kp) — the bc-base ownership/rebuild-trigger feature
  re-scoped here.
- [lead-9pbc](beads:lead-9pbc) — the `BC_LAUNCHER_DISPATCH_TOKEN` 401 blocker
  the fan-in produced; removed from steady state by D3.
- [lead-9ja4](beads:lead-9ja4) — the wrong-repo-pin finding this ADR
  generalizes to `shop-msg` and `beads` (finding 2).
- [lead-aj5f](beads:lead-aj5f) — bc-launcher now public, simplifying credentials.
- [lead-pw41](beads:lead-pw41) / [lead-xq0](beads:lead-xq0) — the
  fix-landed-but-not-live drift class this bc-base line addresses.

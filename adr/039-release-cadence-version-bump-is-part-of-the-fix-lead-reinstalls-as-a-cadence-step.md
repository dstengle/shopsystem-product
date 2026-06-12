# ADR-039 — Release cadence for lead-facing packages: a version bump is part of the fix, the release is dispatched as `request_maintenance`, and the lead reinstalls (and re-pours the fleet) as a cadence step

**Status:** accepted (2026-06-12)
**Tier:** system-global (per [ADR-034](034-system-global-adr-home-in-the-lead-repo-distinct-from-framework-adr.md) / [ADR-035](035-three-tier-adr-hierarchy-and-periodic-system-architect-review-cadence.md) — this is a cross-BC delivery decision about how *this* product's lead host receives the lead-facing surfaces of its BCs; it governs three BCs' release behavior and the lead's own reinstall cadence. Not framework doctrine, not one BC's internals.)
**Authors:** dstengle, Claude (lead-architect)
**Pins:** the delivery-currency discipline surfaced on `lead-5wky` (umbrella) and `lead-n4r2` (templates re-pour) this session — *a BC fix that changes a lead-facing surface is invisible to the lead host (and to any newly-instantiated product) until a version bump + release + reinstall closes the loop; the version bump is not optional, because pip cannot deliver a same-version `@main` reinstall.*
**Anchored to:** [ADR-018](018-empirical-verification-is-contract-surface.md) (the lead carries no `repos/` BC source — so the lead receives BC IP only as *installed packages* and *emissions*; this ADR is about the installed-package channel specifically); [ADR-036](036-procedural-preconditions-are-cli-layer-judgment-behaviors-are-template-prose.md) + `lead-vhfa` (the BC pre-emit gate FALSE-BLOCKS release/tag-deliverable maintenance — the dependency D4 cross-links, does not re-solve); [ADR-015](015-nudge-message-type.md) (the `--force` / forced-recovery escape valve that keeps a bare reinstall possible when the cadence is mid-repair).
**Anchored on (PDR):** [PDR-014](../pdr/014-lead-skill-group-pour-and-graduation-path.md) (the pour/graduation path whose *delivery* leg this ADR's D3 re-pour step closes); [PDR-011](../pdr/011-empirical-verification-is-contract-surface.md) (artifact-surface verification — the reason the lead's only window onto a BC fix is the installed package, not a clone).
**Related beads:** `lead-5wky` (the release-cadence/delivery-currency umbrella this ADR ratifies), `lead-n4r2` (the templates version-bump+tag+re-pour batch this ADR's D2/D3 govern), `lead-slkk` (the v0.3.0 templates publish precedent — the release-then-reinstall pattern), `lead-m56e` / `lead-vhfa` (the pre-emit-gate exemption D4 depends on), `lead-53y0` (the in-flight bc-launcher `product:` fix that gates the bc-launcher release in the backlog).

---

## Context

1. **The lead host runs INSTALLED packages, not BC source.** Per ADR-018 the
   lead carries no `repos/` BC clone; its only window onto a BC's lead-facing
   surface (the `shop-msg` CLI, the canonical templates served by
   `shop-templates`, the `bc-container` launcher) is the **pip-installed
   distribution**. A BC fix that lands on the BC's `origin/main` is therefore
   **invisible to the lead** — and to any product newly instantiated from the
   lead's installed toolchain — until that distribution is re-released and the
   lead reinstalls.

2. **A same-version `@main` reinstall is a NO-OP — proven hard this session.**
   Attempting to deliver the `lead-tgsb` SYSTEM_SLUG fix to the lead host via
   `pip install -U "shopsystem-messaging @ git+…@main"` **no-op'd**: the BC had
   merged the fix to `origin/main` **without bumping the version** (`0.2.1 ==
   0.2.1`), so pip saw "already satisfied" and delivered nothing. Only
   `pip install --force-reinstall --no-deps` delivered it (verified
   `_get_system_slug` present afterward). This is the **central hole**: without
   a version bump, the released package cannot be delivered by ordinary pip
   resolution, and every lead / new product is pinned to a stale CLI.

3. **`--force-reinstall` is not an acceptable delivery path for the spike.**
   The WS-0 genericity spike's "documented path" must drive a freshly
   instantiated product over **real, installable, released tools** — not over a
   `--force-reinstall` workaround that no product instantiation would naturally
   perform. So the cadence must make `pip install -U` (ordinary resolution)
   sufficient, which requires the version bump (Context 2).

4. **Three lead-facing packages are affected, each with a distinct lag shape.**
   Verified via `pip show` on the lead host 2026-06-12:
   - `shopsystem-messaging` (`shop-msg`) — installed **0.2.1**; multiple fixes
     on `origin/main` unreleased; exhibits the *merge-without-bump* hole
     (Context 2).
   - `shop-templates` (canonical templates) — installed **0.2.0**; the BC has
     already published **v0.3.0** at the bootstrap layer (`lead-slkk`
     close-reason, HEAD `254159e`) yet the **lead never reinstalled**, *and*
     further fixes have landed on `origin/main` since. So templates exhibits
     **both** lag shapes: released-but-not-reinstalled, and merged-but-not-yet-
     released.
   - `shopsystem-bc-launcher` (`bc-container`) — installed **0.2.8**; fixes on
     `origin/main` unreleased; one further fix (`lead-53y0`, the manifest
     `product:` resolution+injection) is **in flight**, not yet landed — so its
     release must wait.

5. **Templates additionally must RE-POUR, not just reinstall.** `shop-templates`
   is not only a CLI the lead invokes; it is the source of the canonical
   templates/skills *poured into running BCs and into newly-launched leads*
   (PDR-014). So delivering a templates fix to the live system is a two-step
   close: reinstall the package on the lead host **and** re-pour the running
   fleet (the `lead-n4r2` batch). Reinstall alone leaves running BCs on stale
   poured IP.

6. **Release/tag-deliverable maintenance has no red-before-green test — the BC
   pre-emit gate FALSE-BLOCKS it.** `lead-vhfa` documents that a legitimately
   complete tag-deliverable maintenance (cut v0.2.5 + trigger publish) came back
   `status=blocked` purely on two pre-emit preconditions: the
   work_id-on-`origin/main`-HEAD reachability check (a tag deliverable is
   correctly *not* on HEAD) and the clean-tree check (tripped on the BC's own
   `.beads/issues.jsonl` churn). The fix is the `bc-emit` wrapper's
   release/tag-deliverable mode + carve-outs, **carried by `lead-m56e` / ADR-036
   D1**. ADR-039's D2 release dispatches will hit this same false-block until
   that lands; this ADR **depends on, and does not re-solve, that exemption** —
   it cross-links it as a gating dependency (D4).

This is a delivery-mechanics / convention decision with no product-UX surface
change — hence an **ADR**, not a PDR.

### Pre-state empirical findings (artifact surface, ADR-018 D1/D2)

Verified from the lead CWD (`/workspaces/shopsystem-product`) on 2026-06-12
against `pip show`, this repo's `adr/`/`pdr/`, and the `bd` registry. No BC
source read, run, or git-observed (ADR-018 D1).

1. **Installed versions CONFIRMED via `pip show`:** `shopsystem-messaging`
   **0.2.1**, `shop-templates` **0.2.0**, `shopsystem-bc-launcher` **0.2.8**.

2. **The merge-without-bump no-op CONFIRMED at the artifact level** by the
   `lead-5wky` recorded observation (the `pip install -U …@main` no-op /
   `--force-reinstall` recovery for `lead-tgsb`). This is the defect the bump
   discipline (D1) closes.

3. **The templates released-but-not-reinstalled lag CONFIRMED** by the
   `lead-slkk` close-reason (templates published v0.3.0, HEAD `254159e`) read
   against the installed **0.2.0** from finding 1 — the published tag exists; the
   lead simply never ran the reinstall step. This is the gap D3 closes.

4. **The pre-emit-gate false-block on release/tag deliverables CONFIRMED** by
   `bd show lead-vhfa` (the `lead-if8q` v0.2.5 maintenance returned
   `status=blocked` despite the tag + image being independently confirmed on the
   lead-side artifact surface). The remedy is `lead-m56e` step 1 / ADR-036 D1,
   still OPEN and gated on `lead-yxsr`. D4 records this as a dependency, not a
   thing this ADR solves.

5. **The unreleased-fix work_ids CONFIRMED CLOSED on the lead beads registry**
   (`bd show`): messaging — `lead-tgsb`, `lead-j4ne`, `lead-1r27`, `lead-f1ui`
   all CLOSED; templates — `lead-f3gm`, `lead-0nc8`, `lead-hdn3`, `lead-ajc9`
   all CLOSED; bc-launcher — `lead-6ze3`, `lead-xntx` CLOSED, `lead-53y0` OPEN
   (in flight). "CLOSED on the lead registry" means the lead reconciled the BC's
   `work_done` — the fix is on the BC's `origin/main`; it does **not** mean it is
   released. That release gap is exactly what this ADR's cadence closes.

6. **@scenario_hash retirement enumeration. CONFIRMED — empty.** This is a
   delivery-cadence / convention decision; it authors no Gherkin and retires no
   pinned coverage. The release dispatches it *governs* (D2) are
   `request_maintenance` carrying no scenarios, so they retire no hashes either.

---

## Decision

### D1 — The version bump is part of the fix; a BC bumps its own package version when a fix changes a lead-facing surface

A BC fix that changes a **lead-facing surface** (the `shop-msg` CLI, the
canonical templates `shop-templates` serves, the `bc-container` launcher
behavior, or these packages' public API/schema) MUST carry a **package version
bump** — performed **by the BC, inside its own gated loop**, as part of the same
work, before/with the `work_done`. Merging the fix to `origin/main` without a
bump is the defect Context 2 documents: it makes ordinary `pip install -U …@main`
a no-op and leaves the released artifact undeliverable without `--force-reinstall`.

The bump is **semver-by-surface-impact**, judged by the BC: patch for a
backward-compatible internal fix, minor for an additive lead-facing capability,
major for a breaking change to a lead-facing contract. The BC owns the judgment
(BC sovereignty, ADR-017); the lead reconciles the bump as part of `work_done`
(the version appears in the BC's demonstration). This closes the
"0.2.1 == 0.2.1" hole at its source.

### D2 — The release (tag + publish) is dispatched as `request_maintenance`; a per-fix bump (D1) rides each fix, a periodic batched tag cuts the release

Two operations are distinguished:

- **The per-fix version bump (D1)** rides *each fix* automatically, in the BC's
  loop — it is part of the fix, never a separate dispatch.
- **Cutting the release** — pushing the version tag that triggers the BC's
  publish workflow (and any downstream rebuild, e.g. bc-base for the launcher) —
  is dispatched by the lead as a **`request_maintenance`** to the BC *after a
  fix-batch has landed*. The message-type discriminator selects
  `request_maintenance`: cutting a tag is a **flat, value-only** operation that
  introduces **no new scenarios** and tightens no existing behavior (Architect
  template discriminator Q3 → flat). This matches the `lead-slkk` / `lead-if8q`
  precedent (release-mechanics maintenance) exactly.

**The chosen shape is per-fix bump + periodic batched tag**, not bump-and-tag on
every fix. Rationale: bumping the version with each fix (D1) is cheap and keeps
the artifact always-deliverable, but cutting a *release tag* per fix would
produce tag churn and a publish-workflow run per commit. Batching the tag — one
`request_maintenance` that cuts a release covering a landed fix-batch — is
cleaner: it produces one publish run, one reinstall, one re-pour (templates) per
batch. The per-fix bump guarantees the batched tag always names a strictly
higher version than the last release, so the eventual reinstall is never a no-op.

### D3 — The lead reinstalls from the new release as a cadence step; for templates, it ALSO re-pours the running fleet

After a release tag is published (D2), the **lead** closes the loop:

- **Reinstall** the lead-facing package on the lead host from the new tag via
  ordinary resolution — `pip install -U "<pkg> @ git+<url>@<tag>"` (or the
  index, once published) — which is now **sufficient** because D1 guaranteed a
  higher version. `--force-reinstall` is retained only as a forced-recovery
  escape valve (ADR-015 posture), never the standard path.
- **For `shop-templates` specifically, ALSO re-pour the running fleet** (the
  `lead-n4r2` step): reinstalling the package on the lead host updates the
  *source* of canonical templates/skills, but running BCs and already-launched
  leads carry *poured* copies (PDR-014). The cadence is incomplete until those
  are re-poured from the freshly reinstalled templates.

This reinstall+re-pour cadence is made a **standing operational step**, realized
as a `bin/` helper (e.g. `bin/reinstall-lead-tools` and a templates re-pour
companion) and folded into **session-close** so delivery currency is checked
every session rather than drifting. The session-close routine gains: verify
installed lead-facing package versions against the latest published tags;
reinstall any that lag; re-pour the fleet if templates moved.

### D4 — Pre-emit-gate exemption for release/tag-deliverable maintenance is a DEPENDENCY, cross-linked, NOT re-solved here

The D2 release dispatches are `request_maintenance` whose deliverable is a
**tag** (and a publish-workflow run), which has **no red-before-green test**.
The BC pre-emit gate as it stands FALSE-BLOCKS exactly this (Context 6 /
`lead-vhfa`): the work_id-on-`origin/main`-HEAD reachability check fails because
the tag deliverable is correctly not on HEAD, and the clean-tree check trips on
ambient bead churn. The remedy is the `bc-emit` wrapper's **release/tag-
deliverable reachability mode** + **ambient-artifact carve-outs** +
**self-resolve (never-punt-to-lead) error text**, all carried by **`lead-m56e`
step 1 / ADR-036 D1** and gated on `lead-yxsr`.

ADR-039 **depends on that exemption landing** for its D2 dispatches to complete
cleanly. This ADR does **not** re-solve the exemption — it is already designed
and tracked. The standing instruction: a D2 release `request_maintenance`
dispatched **before** the `lead-m56e`/`lead-vhfa` exemption lands will likely
return `status=blocked` on the false-block; the router accepts the deliverable
on the lead-side artifact surface (tag deref + publish-run confirmation) by
router judgment (the `lead-if8q` precedent) until the wrapper exemption removes
the false-block. After the exemption lands, the false-block disappears and the
release maintenance completes `status=complete` on its own.

### D5 — Consequence as a decision: a product instantiated from releases inherits all genericity fixes; the spike re-runs on real installs

Because the cadence (D1–D3) guarantees that every lead-facing fix reaches a
published, ordinary-pip-installable release, a **newly instantiated product**
built from the lead toolchain inherits *all* the genericity/delivery fixes
(SYSTEM_SLUG, manifest `product:`, self-contained templates, between-item drain,
worktree placement, …) without any `--force-reinstall` workaround. This is the
property the WS-0 genericity spike requires: its "documented path" re-runs over
**real released tools**, validating the genericity end-to-end rather than over a
hand-forced install no product would perform.

---

## Alternatives considered

**Option A — Keep delivering via `pip install --force-reinstall …@main` (status
quo workaround).** Rejected (D1, Context 3). `--force-reinstall` is not a path
any product instantiation naturally performs, so it cannot validate the WS-0
spike's "documented path," and it masks the merge-without-bump defect rather than
closing it. It also silently re-installs unrelated `@main` drift, not a pinned
release. The version bump makes ordinary resolution sufficient; that is the fix.

**Option B — Bump AND cut a release tag on every single fix (no batching).**
Rejected as the primary shape (D2). Per-fix bumps are kept (cheap, keep the
artifact deliverable), but a release tag + publish run + lead reinstall +
fleet re-pour per fix is heavy churn for no benefit when fixes land in batches.
The per-fix-bump + periodic-batched-tag shape gives one publish/reinstall/re-pour
per batch while the per-fix bump still guarantees the batched tag is a strictly
higher version (so the reinstall is never a no-op). Batching is an operator knob;
a single urgent fix can still be released as a batch-of-one.

**Option C — Have the LEAD bump the version / cut the tag.** Rejected (D1, D2,
ADR-018/ADR-017). The lead carries no BC source (ADR-018) and never commits into
a BC repo (BC sovereignty, ADR-017). The bump is a change to the BC's own
`pyproject`/version — a BC-owned artifact. The lead's role is to *dispatch* the
release `request_maintenance` (D2) and to *reinstall* on its own host (D3), not
to author BC-repo changes. The same `lead-vhfa` finding explicitly rejects the
lead acting on BC-repo state.

**Option D — Couple the reinstall into the release dispatch (one combined
step).** Rejected (D3). The release (BC-side: tag + publish) and the reinstall
(lead-side: `pip install -U` + fleet re-pour) live on different hosts with
different owners and a real ordering dependency (the package must be published
before the lead can pull it). They are two cadence steps, not one; conflating
them hides the lead's standing reinstall obligation that has *already* been
missed once (templates v0.3.0 published, lead still on 0.2.0 — finding 3).

**Option E — Solve the release/tag-deliverable pre-emit-gate false-block inside
this ADR.** Rejected (D4). That false-block is already analyzed (`lead-vhfa`)
and its remedy designed and tracked (`lead-m56e` / ADR-036 D1). Re-solving it
here would duplicate and risk diverging from the ratified wrapper design. ADR-039
cross-links it as a dependency and records the interim router-judgment acceptance
posture; it does not re-decide it.

---

## Consequences

- **The merge-without-bump hole (Context 2) is closed at its source** (D1): the
  BC bumps as part of every lead-facing fix, so ordinary `pip install -U` always
  delivers. `--force-reinstall` demotes to a forced-recovery escape valve only.
- **A standing release cadence exists** (D2/D3): per-fix bump → periodic batched
  release `request_maintenance` → lead reinstall → (templates) fleet re-pour,
  folded into session-close and realized as `bin/` helpers. Delivery currency is
  checked every session, not left to drift (the templates 0.2.0-vs-0.3.0 drift is
  the cautionary precedent).
- **A `bin/` helper + session-close addition is implied** (D3) — an operational
  follow-up: a `bin/reinstall-lead-tools` that verifies installed lead-facing
  versions against latest published tags, reinstalls laggards, and triggers the
  templates re-pour. **Flagged as a follow-up, not authored by this ADR.**
- **The WS-0 genericity spike unblocks** (D5): once the three packages are
  released-and-reinstalled, the spike re-runs over real installable tools, the
  property it exists to validate.
- **D2 release dispatches are gated on the pre-emit-gate exemption** (D4): until
  `lead-m56e` / `lead-vhfa` (ADR-036 D1) lands, a release `request_maintenance`
  returns `status=blocked` on the false-block; the router accepts the deliverable
  by lead-side artifact-surface confirmation (tag deref + publish-run) per the
  `lead-if8q` precedent. After the exemption lands, the false-block disappears.
- **Ordering constraint on the bc-launcher release**: the bc-launcher release
  (D2) waits for the in-flight `lead-53y0` (`product:` resolution+injection,
  ADR-038) to land, so its release ships the complete genericity set rather than
  a partial one. messaging and templates have no such in-flight gate and can be
  released first.
- **No tier collapse.** This is a system-global decision (per-product, cross-BC:
  it governs three BCs' release behavior and the lead's reinstall cadence); it is
  not framework doctrine and not one BC's internals. Tagged `system-global` per
  ADR-034.
- **No Gherkin authored, no dispatch sent, no `@scenario_hash` retired** here
  (finding 6). The execution backlog this ADR enables is recorded on `lead-5wky`
  / `lead-n4r2` and reported alongside this ADR for the router to dispatch.

## Cross-references

- [ADR-018](018-empirical-verification-is-contract-surface.md) — the lead carries
  no `repos/` BC source, so it receives BC IP only as installed packages +
  emissions; this ADR governs the installed-package channel.
- [ADR-017](017-bc-side-bead-creation.md) — BC sovereignty; the BC owns its
  version bump and tag (D1/D2/C), the lead never edits BC-repo state.
- [ADR-036](036-procedural-preconditions-are-cli-layer-judgment-behaviors-are-template-prose.md)
  / [lead-vhfa](beads:lead-vhfa) / [lead-m56e](beads:lead-m56e) — the
  release/tag-deliverable pre-emit-gate exemption D4 depends on (does not
  re-solve).
- [ADR-015](015-nudge-message-type.md) — the forced-recovery escape valve that
  keeps `--force-reinstall` available when the cadence is mid-repair.
- [ADR-034](034-system-global-adr-home-in-the-lead-repo-distinct-from-framework-adr.md)
  / [ADR-035](035-three-tier-adr-hierarchy-and-periodic-system-architect-review-cadence.md)
  — the tier model this ADR is filed under (system-global).
- [PDR-014](../pdr/014-lead-skill-group-pour-and-graduation-path.md) — the
  pour/graduation path whose delivery leg D3's re-pour closes.
- [PDR-011](../pdr/011-empirical-verification-is-contract-surface.md) —
  artifact-surface verification; the reason the lead's window onto a BC fix is
  the installed package.
- [lead-5wky](beads:lead-5wky) — the release-cadence/delivery-currency umbrella
  this ADR ratifies; [lead-n4r2](beads:lead-n4r2) — the templates
  version-bump+tag+re-pour batch (D2/D3); [lead-slkk](beads:lead-slkk) — the
  v0.3.0 templates publish precedent; [lead-53y0](beads:lead-53y0) — the
  in-flight bc-launcher fix gating its release.

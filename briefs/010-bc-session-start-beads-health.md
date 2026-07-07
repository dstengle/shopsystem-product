---
id: BRIEF-010
kind: brief
title: "Brief 010 — BC session-start beads-health: set up AND validate the work-tracker before work begins"
status: draft
date: "2026-06-11"
description: "Brief 010 — BC session-start beads-health: set up AND validate the work-tracker before work begins"
beads: [lead-80t0, lead-po, lead-rply, lead-vlsu]
edges:
  supersedes: []
  superseded-by: []
  amends: []
  depends-on: []
  anchored-on: []
  pins: []
  related: []
---
# Brief 010 — BC session-start beads-health: set up AND validate the work-tracker before work begins

**Status:** draft (2026-06-11)
**Authors:** dstengle (stakeholder), Claude (lead-po)
**Lead bead:** [`lead-80t0`](#) — BC session-start: set up AND validate beads
health at session-start (detect/heal a wedged tracker).
**Anchored to:** stakeholder direction, session 2026-06-11 (verbatim):

> "We keep running into beads issues. The BC startup needs to have a skill for
> setting up AND validating beads health."

**Cross-links (NOT duplicates — see §"Relationship to lead-rply / lead-vlsu"):**

- [[lead-rply]] — the bc-launcher *provisioning* fix (upstream cause: launcher
  derives prefix from BC name and never imports the committed jsonl). This
  brief is the BC-side *defense-in-depth* complement, not the same work.
- [[lead-vlsu]] — the upstream `bd` init-safety deadlock (no non-destructive
  prefix-adoption path once wedged). Lead-level / upstream-bd finding, not a
  BC dispatch.

---

## 1. Frame the problem first — the request is solution-shaped

The request arrives as a solution ("needs a skill for X"). Before converging on
a skill, name the actual job-to-be-done so the capability is pinned to the
outcome, not the mechanism.

**Job-to-be-done:** *A BC begins its work with a trustworthy, writable
work-tracker — or it is told clearly, at startup, why it cannot, and stops
there.*

The motivating failure is concrete and has now recurred, so this framing pass
is deliberately light.

**Pains (observed, this session and before):**

- **Silent broken tracker.** A BC (shopsystem-templates) launched with an
  embedded-Dolt `bd` backend that had an *empty* working set and *no*
  `issue_prefix`, while the committed `.beads/issues.jsonl` carried 23 issues
  under prefix `tmpl`. Nothing at startup flagged this; the BC proceeded as if
  the tracker were healthy.
- **Late discovery.** The breakage surfaced only at the *end* of the role loop:
  the work-done-gate's Check 4 ("≥1 RED plan sub-issue, all closed") was
  *unsatisfiable* because no issue could be created or read. Every `work_done`
  was forced to `status=blocked` (`lead-2bdq` `mechanism_observation`). The
  cost of the latent fault was paid at the most expensive point in the loop.
- **Deadlocked recovery.** Once wedged, all five documented `bd` recovery
  commands mutually blocked (`bd init`, `bd init --force`, `bd bootstrap`,
  `bd config set issue_prefix`, `bd rename-prefix`) — see lead-vlsu. The BC had
  no in-loop forward path and could not self-heal without an undocumented
  side-effect.

**Desired outcome:** the trustworthiness of the work-tracker is established and
*proven* at session-start — the cheapest point — so a wedged or unprovisioned
tracker is **caught and healed, or caught and surfaced**, before any role work
depends on it. Never discovered downstream at `work_done`.

This is load-bearing: the entire BC role pipeline (plan sub-issues, the
red-before-green gate, `work_done` emission) sits on a writable tracker.

---

## 2. What this brief commits

A **BC session-start beads-health capability**: when a BC shop's agent session
begins, *before* it accepts or advances role work, it runs a defined
work-tracker health step that:

1. **Detects** whether the BC's `bd` tracker is healthy. "Healthy" requires
   BOTH: (a) the tracker is **locally writable** — the operations the role loop
   depends on (`bd create`, `bd ready`) succeed and a definite `issue_prefix` is
   configured; AND (b) a **test `dolt push`** to the configured Dolt remote
   **succeeds** — a proven remote round-trip. A tracker that accepts local
   writes but cannot push to its remote is **UNHEALTHY**. Local writability
   alone is not sufficient.
2. **Heals** an unhealthy-but-recoverable tracker — specifically the observed
   wedge: empty working set + no prefix + a committed `issues.jsonl` (and/or
   configured `-beads` remote) that names a definite prefix. Heal = adopt the
   committed prefix and import the committed registry so the working set becomes
   populated and writable; then **re-validate, including the test `dolt push`**.
3. **Surfaces and HARD-BLOCKS** — when the tracker cannot be made healthy after
   the heal attempt (including the case where the heal succeeds locally but the
   test `dolt push` fails) — an explicit, actionable health failure *at
   startup*, and **blocks ALL role-work from starting**: the BC does not begin
   its role loop and does not emit any role work, so the fault is visible at the
   cheapest point rather than discovered at `work_done`.

**Delivery vehicle (PO observation, NOT a commitment):** this looks like a
member of the BC-side skill-group that `bc-container launch` already pours into
the BC shop's `.claude/skills/` (features/bc-launcher/43), shaped like the
lead-side `bring-up-bc` skill (features/templates/159–161). The owning BC and
the exact pour/skill vs launcher-step split are the **Architect's**
discriminator + decomposition call at dispatch. The PO commits the *behavior*,
authored against the BC-startup contract surface, not the mechanism.

---

## 3. The heal-vs-block policy — RESOLVED by the stakeholder (2026-06-11)

This was authored as an open recommendation (auto-heal vs always-block). The
stakeholder has now **decided it explicitly**, as a *combination* plus a
sharpened health definition. Verbatim:

> "Auto-heal and block any work from starting if beads is not healthy (must
> include a test dolt push)."

**Resolved policy (DECIDED — not a recommendation):**

1. **Auto-heal the recoverable wedge.** On an unhealthy-but-recoverable tracker,
   attempt the known-safe heal: adopt the committed `issue_prefix` and import
   the committed `issues.jsonl`. (Unchanged from the prior Option-A default.)
2. **Re-validate, then HARD-BLOCK if still unhealthy.** After the heal attempt,
   re-run the full health check. If the tracker is healthy, the BC proceeds. If
   it is **not** healthy — for *any* reason, including no committed prefix to
   adopt OR a heal that succeeded locally but whose test `dolt push` fails — the
   BC **hard-blocks ALL role-work at startup** and surfaces the failure. "Block"
   here is the strong form: the BC does **not begin its role loop and does not
   emit any role work** — not merely "refuse at `work_done` time." The gate is
   at **session-start**.
3. **Health MUST include a proven remote round-trip.** "Healthy" is no longer
   local writability alone. The health check MUST perform a **test `dolt push`**
   to the configured Dolt remote, and that push MUST succeed. A tracker that
   accepts local writes but cannot push to its remote is **UNHEALTHY** and
   blocks.

**Rationale (grounded in the experience, retained):**

- The **silent wedge was the worst outcome** — the capability's whole point is
  to remove the silent-and-late failure mode. Auto-heal removes it for the safe
  mechanical case; the hard-block-at-startup removes it for every other case.
- The heal path is **known and safe**: in the observed case a single
  `bd config set issue_prefix <prefix>` triggered `bd`'s auto-import-on-empty-
  database, importing all 23 committed issues AND adopting the prefix (verified —
  see lead-rply / lead-vlsu empirical notes). The heal is non-destructive: it
  *adopts* committed state, it does not invent or overwrite it (scenario 04).
- **The remote round-trip is load-bearing.** A tracker that is locally writable
  but cannot push is exactly the latent fault class this brief exists to kill:
  work proceeds, issues accrue locally, and the loss surfaces only when a `dolt
  push` is finally attempted — downstream, expensive. Requiring a proven test
  push at startup catches it at the cheapest point.

**Net policy:** *attempt heal → re-validate (local writability AND a successful
test `dolt push`) → proceed only if healthy; otherwise hard-block ALL role-work
at session-start and surface.* The heal remains **non-destructive** (adopt
committed prefix + import committed registry; never fabricate a prefix, never
overwrite committed issues).

This policy is **settled** — it is the stakeholder's explicit decision, not PO
vocabulary open to flip. Scenarios 01–05 below pin it.

---

## 4. Relationship to lead-rply / lead-vlsu — explicitly NOT a duplicate

| Bead | Layer | What it fixes | Why distinct |
|------|-------|---------------|--------------|
| **lead-rply** (bug) | bc-launcher provisioning | The wedge never *occurs* on our launch path: launcher adopts the committed/remote prefix and imports the jsonl on clone, instead of deriving a name-based prefix and leaving the working set empty. | *Prevents* the cause. This brief *detects + heals/surfaces* whatever cause produces an unhealthy tracker — including paths the launcher fix doesn't cover. |
| **lead-80t0** (this brief) | BC session-start skill | The BC *validates* its tracker at startup and self-heals the recoverable wedge, or surfaces an unhealable one — before any role work depends on it. | Defense-in-depth COMPLEMENT to lead-rply. Both can land; together they are belt-and-suspenders on the most load-bearing precondition in the BC loop. |
| **lead-vlsu** (bug) | upstream `bd` tool | `bd` should offer a *documented*, non-destructive prefix-adoption command for the empty-local + configured-remote state, instead of the current 5-way deadlock + undocumented side-effect. | Upstream-bd / lead-level. This brief's heal currently *relies on* the side-effect lead-vlsu wants made first-class; if lead-vlsu lands, the heal step adopts the proper command. Not a BC dispatch. |

The two are **complementary, not redundant**: lead-rply removes the cause at the
launcher; this brief is the per-BC startup guard that catches an unhealthy
tracker from *any* cause and heals or surfaces it. Shipping one does not retire
the other.

---

## 5. Scenarios

Authored as thin, vertical, single-behavior scenarios against the BC-startup
contract surface (the BC agent's session-start behavior and the poured skill's
observable effect on the tracker), NOT implementation detail. See
[`features/beads-health/`](../features/beads-health/). Titles:

1. **01** — session-start detects a healthy tracker — locally writable AND a
   successful test `dolt push` round-trip — and proceeds.
2. **02** — session-start heals a recoverable wedge (adopt committed prefix +
   import committed registry), re-validates *including a successful test `dolt
   push`*, and only then proceeds.
3. **03** — session-start surfaces an unhealable tracker (no committed prefix to
   adopt, so the heal cannot run) as an explicit startup health failure and
   hard-blocks ALL role-work from starting (does NOT begin its role loop, does
   NOT emit any role work; not rediscovered at `work_done`).
4. **04** — the heal is non-destructive: it adopts committed state and does not
   fabricate a prefix or overwrite committed issues.
5. **05** — session-start treats a tracker that is locally writable but whose
   test `dolt push` FAILS as unhealthy, and hard-blocks ALL role-work from
   starting (the remote round-trip criterion, pinned as its own behavior so it
   is not overloaded onto 01/03).

Scenarios 01, 02, 03, 05 pin the decided policy behaviors of §3 (detect-healthy
incl. push; heal-then-revalidate-incl.-push; unhealable→block-all-role-work;
unpushable→block-all-role-work). Scenario 04 pins the non-destructive invariant
that makes the auto-heal safe. The hash and `@bc:` tag are the Architect's to
add at assignment per ADR-018 D2 — these are authored tag-free.

---

## 6. What this brief leaves open (Architect's call at dispatch)

- **Owning BC / vehicle.** Skill poured by `bc-container launch` (sibling of
  features/bc-launcher/43) vs a launcher readiness-barrier step (sibling of
  features/bc-launcher/34) vs a shop-templates-poured BC skill-group member.
  Discriminator + decomposition decision; ADR-shaped if non-obvious.
- **Exact health-probe commands.** The scenarios pin the *outcome* (writable:
  `bd create`/`bd ready` succeed; definite prefix configured; a test `dolt push`
  to the configured remote succeeds), not the precise command sequence used to
  probe — that's BC implementation. (The *test `dolt push` round-trip* is a
  pinned criterion, per the §3 decision; the exact invocation/cleanup of that
  test push is BC implementation.)
- **Heal command surface.** Whether the heal uses the current side-effect path
  or (once lead-vlsu lands) a first-class `bd` adopt command. Scenario 02 pins
  the *effect* (committed prefix adopted + registry imported + now writable +
  test push succeeds), not the command.

The heal-vs-block policy is **no longer open** — resolved by the stakeholder
(§3): auto-heal AND hard-block-all-role-work-at-startup if not healthy, with
health requiring a successful test `dolt push`.

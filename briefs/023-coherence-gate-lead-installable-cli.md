# Brief 023 — the coherence gate ships as a lead-installable CLI (cand-005 Phase 4, first slice)

**Status:** draft (2026-07-16)
**Authors:** David Stenglein (product authority), Claude (lead-po)
**Lead bead:** [`lead-iohr`](#) (P2, OPEN) — reused as the work_id for this
brief's dispatch, per the `lead-jqew9` reuse precedent (cand-005 Phase 2):
`lead-iohr` already names exactly this gap ("Ship coherence gate as a
lead-installable contract-tool CLI (ADR-018 D2)... LEFT OPEN pending PO
authoring", 2026-07-16 architect triage note) and is a child-shaped sibling
of the now-CLOSED epic `lead-ac1f`. This brief is that PO authoring.

**Committed-contract input:** this brief transcribes `cand-005` Phase 4
("Build the actual coherence gate"), a phase of a candidate already ratified
full-chain by the product authority ("fund it all", 2026-07-16). Phase 4
was explicitly named too large/underspecified to dispatch directly and
flagged in `cand-005`'s own Rabbit holes as needing "its own brief with its
own appetite-setting" — this is that brief.

**Anchored to (decisions this builds on — NOT re-decided here):**

- [PDR-032](../pdr/032-knowledge-bc-owns-artifact-type-system.md) — the
  shopsystem-knowledge BC owns the artifact type system and the coherence
  gate, including gate rules 4-8 (net-new) layered on PDR-031's already-on
  typed-edge floor (rules 1-3).
- [ADR-018](../adr/018-empirical-verification-is-contract-surface.md) D2 —
  a **contract tool** is an installed CLI whose input is contract text and
  output is a contract fact, invoked by the lead directly (never by
  dispatching a BC to run it over lead-held text the BC cannot see). This is
  the load-bearing distinction this brief's whole scope rests on — see
  §1.
- `features/shopsystem-knowledge/coherence_gate_typed_edges.feature`,
  `coherence_gate_lifecycle_rules.feature`,
  `coherence_gate_advisory_blocking.feature` — the gate's check LOGIC
  (rules 1-10, the advisory/blocking mode split), already authored, hashed,
  and present in this repo's corpus. This brief does not re-author or alter
  any of these; see §1 and §7.
- `lead-ac1f` (CLOSED epic), `lead-5oih` (CLOSED, mis-scoped), `lead-iohr`
  (OPEN, this brief's target) — the bd history that already diagnosed
  exactly this gap; see §1.

---

## 1. The problem — corrected from the dispatching brief's own assumption

The task that produced this brief assumed the coherence gate has "no
implementation anywhere" and that the check LOGIC itself (link resolution,
bidirectional supersession, `incorporates`-claims, lifecycle conditions)
was what Phase 4 needed to author. Direct corpus discovery (`scenarios
journal rebuild` + `scenarios validate --aggregate` over `features/`, per
this shop's retrieval discipline — not hand-grep) falsifies that
assumption: **the check logic is already fully authored and pinned.**
`coherence_gate_typed_edges.feature` (11 scenarios) covers gate rules 1-3
(asymmetric-supersede, active-yet-superseded, dangling-edge across 7 link
fields, supersede-cycle) — including exactly the "bidirectional
supersession" check the dispatching brief suggested as a first-slice
candidate. `coherence_gate_lifecycle_rules.feature` (12 scenarios) covers
gate rules 4-9 — including exactly the "`incorporates`-claim validation"
check the dispatching brief also suggested (`Scenario: an accepted decision
claimed by no current-state incorporates list is flagged`).
`coherence_gate_advisory_blocking.feature` (4 scenarios) pins the
ADR-047-D3 advisory/blocking mode split. All three files were authored
2026-07-09 (`git log`, commit `2833392`) as part of the handoff-package
ingest; `bd show lead-ac1f`'s close note confirms: "coherence gate
(capability landed+pinned: ADR-059/PDR-032,
coherence_gate_advisory_blocking.feature)". They carry `@scenario_hash`
tags that reproduce exactly (`scenarios list`, verified) but **no `@bc`
tag** (`E_MISSING_BC` on all three, `scenarios validate --aggregate`) —
authored, never dispatched.

**What actually blocked dispatch, and is the real gap:** the gate's Given
clauses all assume an already-parsed "artifact corpus" with no path to one.
`shop-knowledge` exposes no directory-walking command — `shop-knowledge
validate` "takes exactly one document path" (confirmed by direct
invocation), no aggregate mode. This exact gap is already tracked, in
detail, at `lead-iohr` (OPEN, P2): "Ship coherence gate as a
lead-installable contract-tool CLI (ADR-018 D2): `[project.scripts]`
entrypoint + filesystem corpus loader... + authoring-mode doctor-form
verdict... LEFT OPEN pending PO authoring" (2026-07-16 architect triage
note, on the same bead).

**And there is a second, harder-won reason dispatch never happened:**
`lead-5oih`, a prior attempt to close this exact gap by dispatching
shopsystem-knowledge to *run* the gate over 4 lead-held artifacts, was
closed **mis-scoped**: "the gate over LEAD-held typed artifacts is a
contract-tool operation (ADR-018 D2): input=lead's typed artifact texts,
output=doctor-form verdict; it must run lead-side over the lead's own
corpus like `scenarios hash`. Dispatching knowledge to RUN it over
artifacts a BC cannot see... was wrong-shaped." This directly overturns the
dispatching brief's suggestion that Phase 4 "may plug into" `bin/doctor` as
a BC-called check the way ADR-047's *different* coherence gate does.
**ADR-047's gate and PDR-032's gate are two unrelated concerns that happen
to share a name:** ADR-047's is `system-manifest.yaml` component-VERSION
BOM coherence, checked by `bin/system-manifest`/`bin/doctor` against baked
image provenance — nothing to do with the product-artifact cross-reference
graph. `bin/doctor` is not this gate's host.

## 2. The job-to-be-done

*When the lead router (or a PM-mode session, or a future pre-commit hook)
needs to know whether this repo's typed-artifact corpus is internally
coherent — supersession backlinks present, `incorporates` claims resolvable,
lifecycle rules 4-9 holding — I want to run one installed command over the
real directory tree and get a doctor-form verdict, instead of the gate's
already-pinned check logic having no way to ever actually run.*

## 3. The outcome (observable behavior change)

An operator (today, the router; later, a hook) runs `shop-knowledge gate
<corpus-root>` against this repo's real `intent/`, `candidates/`,
`sessions/`, `briefs/`, `pdr/`, `adr/`, and `current-state.md`, and gets
back a doctor-form aggregate verdict exercising the already-pinned rules 1-3
and 4-9 checks — not a hypothetical "given an artifact corpus" scenario
precondition nobody can construct. This closes `lead-iohr` and unblocks
`lead-dprd` (which has depended on it since 2026-07-13). Output (a CLI
command) is not the measure; the outcome is that this repo's real, messy,
mostly-legacy corpus becomes something the already-designed gate rules can
actually be run against and reasoned about — including honestly reporting
the cases they cannot yet verify, rather than staying permanently
un-runnable.

## 4. The pinned solution shape

**shopsystem-knowledge** ships `shop-knowledge gate <corpus-root>` as an
installed `[project.scripts]` entrypoint (ADR-018 D2 contract tool, same
category as `shop-knowledge template`/`schema`/`validate` and `scenarios
hash`):

- A filesystem corpus loader walks the given root's typed-artifact
  locations (`intent/`, `candidates/`, `sessions/`, `briefs/`, `pdr/`,
  `adr/`, `prioritizations/` if present, and `current-state.md` at the
  root) and parses each file's YAML frontmatter.
- Parsed typed documents feed into the **already-pinned, unmodified**
  typed-edge and lifecycle-rule check logic.
- A file with no YAML frontmatter at all (the legacy-corpus reality) is
  excluded from the typed graph proper but is not silently dropped: any
  edge pointing at it is reported as a third, honest verdict —
  **unverifiable-legacy** — distinct from a genuine dangling edge (target
  doesn't exist at all) and distinct from a genuine violation (target is
  typed and fails the rule). Unverifiable-legacy is advisory, never
  blocking by itself, mirroring the same newly-added/pre-existing split
  `bin/check-knowledge-artifacts` (cand-005 Phase 3) already applies for
  the identical reason (most of the real corpus is still legacy prose).
- Defaults to **authoring mode** (advisory, exit 0 on findings) per the
  already-pinned `coherence_gate_advisory_blocking.feature` contract.

## 5. Scope / appetite

**In scope (this brief's 6 new scenarios, §9):** the CLI entrypoint, the
filesystem corpus loader, its wiring into the already-pinned check logic,
and the unverifiable-legacy verdict for legacy (frontmatter-less) edge
targets — grounded in this repo's real corpus (§6).

**Explicitly deferred, named not silently dropped:**

- **Distribution-mode's blocking veto and any adopter-bootstrap
  integration.** Already-pinned (`coherence_gate_advisory_blocking.feature`
  distribution-mode scenarios) but this repo has no adopter stand-up
  surface exercising it yet; wiring it is a follow-on once authoring mode
  is proven live.
- **Any `bin/doctor` wiring.** `bin/doctor` is ADR-047's BOM-coherence
  host, a different concern (§1). If a future additive `bin/doctor` check
  shelling out to `shop-knowledge gate` is wanted, that is a small
  `request_maintenance` to shopsystem-templates once this CLI exists and is
  verified live — not bundled here.
- **Lifecycle TRANSITION-validity checking** (was status X a *legal*
  transition from whatever it was before, e.g. `accepted` reverting to
  `proposed`) — confirmed absent from all 12 already-pinned lifecycle-rule
  scenarios, which check point-in-time cross-document consistency only,
  never transition history. This needs either git-history diffing or an
  explicit transition log — materially larger, undesigned scope, correctly
  excluded per `cand-005`'s own Rabbit holes framing ("least-specified
  phase... its own brief").
- **New link-field coverage.** The already-pinned dangling-edge Scenario
  Outline already covers 7 fields (`supersedes`, `derives-from`, `session`,
  `brief`, `candidate`, `produced`, `incorporates`); this brief adds no new
  fields.
- **The `governed-delta` opt-in tripwire** — zero claims register it today;
  nothing to exercise.

## 6. Grounded in this repo's real artifacts

- **`pdr/034-legacy-corpus-migrates-into-the-typed-artifact-system.md`** is
  the *only* pdr/adr file in this repo with real YAML frontmatter (`for f
  in pdr/*.md adr/*.md; do head -1 "$f" | grep -q '^---$' && echo HAS; done`
  — exactly one hit). Its frontmatter declares `supersedes: [pdr-032]`.
  `pdr-032` is a legacy file (bold-header `**Status:** accepted`, no YAML
  frontmatter at all) — it cannot carry a machine-readable `superseded-by`
  back-edge until Phase 5 migrates it. This is the real, concrete
  unverifiable-legacy case §4/§9 pin, not a hypothetical.
- **`current-state.md`** declares `incorporates: [pdr-032, pdr-033,
  adr-059]` — all three targets are legacy (confirmed: `adr/059` and
  `pdr/033` both use the bold-header `**Status:** accepted` convention,
  zero YAML frontmatter). The same unverifiable-legacy verdict applies to
  all three edges, not a false "accepted" pass and not a false
  "unincorporated" violation.
- **`prioritizations/`** genuinely does not exist yet (`find -maxdepth 1
  -iname prioritizations` — no hit, reconfirmed 2026-07-16) — the real
  instance backing the "absent typed-artifact directory" scenario (§9, S5).

## 7. Dispatch target

**shopsystem-knowledge**, not a two-BC split. The CLI, the loader, and the
check logic it wraps all live in one BC per PDR-032's ownership grant; there
is no `bin/doctor` (shopsystem-templates) leg in this slice (§5). The
Architect should reuse `lead-iohr` as the `work_id` (it already names this
exact gap and is the correct bd node to close).

**Recommendation for the Architect, not this brief's own scenario set:**
`coherence_gate_typed_edges.feature`, `coherence_gate_lifecycle_rules.feature`,
and `coherence_gate_advisory_blocking.feature` require **zero new PO
authoring** — they are complete, hashed, and structurally valid (their only
`scenarios validate` findings are the expected pre-dispatch `E_MISSING_BC`/
`E_MISSING_ORIGIN`, not defects). The CLI this brief pins is inert without
that check logic, and that check logic has had no caller for the same
reason it's never been dispatched. Bundle all four files into one
`assign_scenarios` dispatch to shopsystem-knowledge.

## 8. What would NOT satisfy the stakeholder

- A CLI that re-derives or duplicates the already-pinned check logic
  instead of wrapping it — doubles the maintenance surface PDR-032/ADR-059
  exist to prevent.
- A loader that silently drops legacy (frontmatter-less) targets, hiding
  that an `incorporates`/`supersedes` claim exists and cannot be verified —
  the exact silent-drift failure mode `cand-005` exists to close.
- A loader that reports every legacy target as a hard violation — fabricates
  ~90 false defects `cand-005` Phase 5 is what will actually fix, and would
  make the gate unusable on this repo's real corpus today.
- Bundling `bin/doctor` wiring or distribution-mode blocking into this
  dispatch — conflates two different coherence concerns (§1) and expands
  appetite past a first slice.

## 9. Pinned scenarios

Authored, hashed via the installed `scenarios hash` CLI (block-only
canonicalization), and written to disk at
[`features/shopsystem-knowledge/coherence_gate_lead_installable_cli.feature`](../features/shopsystem-knowledge/coherence_gate_lead_installable_cli.feature):

- `@scenario_hash:25628c9bd2e401d6` (S1) — the gate command walks a real
  directory tree and feeds typed documents into the already-pinned checks
  (positive case: a resolved supersede pair passes clean).
- `@scenario_hash:5184003b24ca939e` (S2) — a `supersedes` edge to a target
  file with no YAML frontmatter is reported unverifiable-legacy, not
  dangling or asymmetric (grounded in the real `pdr-034`→`pdr-032` case,
  §6).
- `@scenario_hash:bfb4ce1264d5021c` (S3) — a `current-state` `incorporates`
  claim naming a legacy decision is reported unverifiable-legacy, not as an
  unincorporated-decision violation (grounded in the real `current-state.md`
  case, §6).
- `@scenario_hash:d0f0ad4d25aa409a` (S4) — a link-field target with no
  corresponding file anywhere in the corpus is still reported dangling,
  distinct from the legacy case (the negative control distinguishing S2/S3
  from a real defect).
- `@scenario_hash:cd8e26dccaf8ddb3` (S5) — an absent typed-artifact
  directory (`prioritizations/`, real, §6) does not crash the loader.
- `@scenario_hash:82d9df6a97c9a173` (S6) — the gate command defaults to
  authoring mode.

`scenarios list features/shopsystem-knowledge/coherence_gate_lead_installable_cli.feature`
reproduces all six hashes exactly against the on-disk file, verified before
this brief was written. `scenarios validate` on the file reports one
expected pre-dispatch finding (`E_UNKNOWN_ORIGIN` on `@origin:brief-023`,
resolved once this brief lands in the origin registry) and, once `@bc` is
assigned at dispatch, no further findings.

## 10. Strategic trace

Traces to `cand-005` Phase 4 ("Build the actual coherence gate"), itself
committed full-chain by the product authority, deriving from `intent-007`.
Also closes the standing bd gap `lead-iohr` (discovered from the now-closed
epic `lead-ac1f`) and unblocks `lead-dprd`, both pre-existing and
independently tracked — this brief is not inventing new strategic intent,
it is the PO authoring that two already-committed bd nodes were waiting on.

## Housekeeping

**On why this brief's appetite is much smaller than the dispatching task
assumed:** the task that produced this brief asked for a first slice of
"gate rules 4-8" reasoning from the premise that no check logic existed.
Direct corpus discovery overturned that premise before any scenario was
written — re-authoring already-pinned rules would have been pure
duplication, exactly the failure this shop's retrieval discipline (`scenarios
journal rebuild`/`validate --aggregate`, not hand-grep) exists to catch.
The real remaining gap, once found, was narrow enough that a "first slice"
framing barely applies: this brief is very nearly all of what's left before
Phase 4 can be dispatched and verified end to end. The two items named in
§5 as deferred (transition-validity, distribution-mode/`bin/doctor`
wiring) are the genuine remainder.

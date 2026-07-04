# Reference-data pipeline that makes `scenarios validate` work on the REAL corpus

**Date:** 2026-07-04 · **Branch:** `dagger-spike` · **Lead shop:** shopsystem-product
**Epic:** `lead-vzxd` · **Guard:** `lead-vzxd.1` (built + verified SOUND; needs
real-shaped reference data). **Links:** `lead-bh2m` (DDD context map).
**Status:** DESIGN + lead-side artifact work landed. NO `shop-msg` send (router
sends). All verification is artifact/contract-surface only (ADR-018 D1/D2).
**Companion records:** ADR-056 (schema + D10 known-value sets), ADR-018 (no
cross-BC source on any host), ADR-005 (`bc-manifest.yaml` ownership), ADR-039
(release cadence — version bump is part of the fix), ADR-050 (bc-launcher
container provisioning), ADR-028 (services model).
**Builds on:** `00-design.md`, `01-reference-data-sourcing.md`.

---

## 0. Verified pre-state (empirical, this session)

The released `scenarios validate` capability is INSTALLED (`scenarios` pkg
`0.2.0`, main `7b6bacc`) and runs. A conformant file validates exit 0 GIVEN a
string-list `@bc`/`@service` index and a resolvable `@origin`. Two real-shape
gaps block it on the REAL corpus — both reproduced this session:

**GAP-1 (`@bc`/`@service`) — crash on the real manifest.** `_load_manifest`
does `frozenset(data.get('bcs'))` (`validate.py:271`) expecting `bcs:`/
`services:` to be STRING lists. The real `bc-manifest.yaml` carries DICT entries
(`- name: X, remote:.., role:.., [status, deferred_to]`). Reproduced:

```
$ scenarios validate --manifest /workspace/bc-manifest.yaml --origin-root /workspace/adr probe.feature
TypeError: unhashable type: 'dict'   (validate.py:271, frozenset(bcs))
```

`services:` has the same shape → the same crash. This is a hard crash (traceback,
not a diagnostic), so it is strictly worse than a schema violation.

**GAP-2 (`@origin`) — real ADR filenames don't match the lookup, and a BC has
no `adr/` dir.** `_origin_resolves` (`validate.py:288`) looks for `<ref>.md`
(e.g. `adr-056.md`) under the origin roots + their `adr/pdr/briefs` subdirs.
The real files are `NNN-slug.md` (`056-scenario-…​.md`), NOT `adr-056.md`, so
`@origin:adr-056` fails `E_UNKNOWN_ORIGIN`. Reproduced against a string-list
projection manifest (isolating GAP-2 from GAP-1):

```
$ scenarios validate --manifest proj.yaml --origin-root /workspace/adr probe.feature
probe.feature:3: E_UNKNOWN_ORIGIN: @origin value 'adr-056' resolves to no known decision record
```

Compounding: a per-BC validator running INSIDE a BC container has NO `adr/`
tree to scan at all (ADR-018) — so any filesystem-dir-scan origin model is
BC-side non-viable regardless of the filename shape.

Both fix-shapes were then PROVEN (below): the hardened format validates
`probe.feature` exit 0 against the real dict-entry manifest and the generated
origin-index, with `origin_roots=[]` (no `adr/` dir — the BC-side posture).

---

## 1. Finalized index format + rationale

### Decision 1a — `@bc`/`@service`: HARDEN the validator; `bc-manifest.yaml` is the single source

**Decision:** harden the validator's `_load_manifest` to extract `name` from
structured `bcs:`/`services:` DICT entries (and still accept bare-string
entries, so the existing `tests/22-scenarios` string-list fixtures keep
passing), tolerating `status` / `deferred_to` / `remote` / `role` and any other
additive keys. The REAL `bc-manifest.yaml` then serves BOTH launch and
validation as ONE curated source of truth.

**Rejected:** the lead generates + provisions a separate string-list
`@bc`/`@service` PROJECTION. That re-introduces exactly the drift ADR-005's
single-committed-registry doctrine exists to prevent: two artifacts (the
structured manifest bc-launcher launches from, and the projected list the
validator reads) that can silently diverge. Kept only as the fallback if a
consumer ever needs the projection standalone.

**Consequence:** NO `@bc`/`@service` artifact is generated. `bc-manifest.yaml`
(already committed at the ADR-005 well-known repo-root path) IS the
`@bc`/`@service` reference; bc-launcher provisions it as-is. Name-extraction
includes the provisional entries (`shopsystem-test-harness`,
`shopsystem-devcontainer`) as legal `@bc` VALUES — correct: they are defined
contexts; whether they actually OWN scenarios is the `lead-bh2m` /
aggregate-gate question, not a per-file legality question.

### Decision 1b — `@origin`: generated identifier LIST + a small validator change (membership)

**Decision:** the validator gains a `--origin-index <file>` flag that loads a
flat list of legal `@origin` identifiers and resolves `E_UNKNOWN_ORIGIN` by SET
MEMBERSHIP (plus the existing `unresolved` sentinel and the existing lead-bead
prefix rule). The lead generates + commits that list (`scenario-refs/
origin-index.txt`) from `adr/` `pdr/` `briefs/` filenames.

**Rejected:** the lead generates an origin marker-DIR (`<id>.md` empty files)
that the existing dir-scan resolves (zero validator change). Reasons the
list-file wins:
1. **It is the only shape the design blessed** — `00-design`/`01` call for a
   "generated identifier LIST", not N marker files.
2. **Cleaner + auditable** — one diffable artifact whose CONTENT is the set,
   vs. ~112 empty files whose only signal is their names (un-diffable content,
   noisy tree).
3. **BC-side ADR-018 viability is identical** either way (the launcher
   provisions whichever), but the list is the natural provisioned unit and does
   not masquerade as a `adr/`-style tree the BC must not have.

The validator change is SMALL and ADDITIVE: `--origin-root` (dir-scan) stays
for the fixtures; `--origin-index` (membership) is the real/BC-side path;
`_origin_resolves` checks the index set first, then falls through to the
existing sentinel + bead-prefix + dir-scan logic. Graceful: a missing index
file yields an empty set (no crash), mirroring the missing-manifest handling.

### The finalized reference bundle (what bc-launcher provisions)

| Input | Artifact | Source | Validator seam |
|-------|----------|--------|----------------|
| legal `@bc`/`@service` | `bc-manifest.yaml` (structured, as-is) | ADR-005 curated registry | `--manifest` (hardened name-extraction) |
| legal `@origin` | `scenario-refs/origin-index.txt` (generated list) | `bin/gen-scenario-refs` over `adr/`+`pdr/`+`briefs/` | `--origin-index` (membership) |
| lead bead ids | (none — dynamic) | validator prefix rule (`lead-*` / `shopsystem-*`) | unchanged |

`@origin` resolves by EXISTENCE-IN-INDEX; no ADR/PDR/brief bodies are ever
shipped to a BC. This is what makes the whole thing tractable under ADR-018.

### Origin identifier shapes emitted

`adr-NNN` (from `adr/NNN-*.md`), `pdr-NNN` (from `pdr/NNN-*.md`), and BOTH
`brief-NNN` and `brief-<slug>` for `briefs/NNN-*.md` — ADR-056 D2 cites
`brief-<slug>` while `adr-`/`pdr-` are numeric, so the index carries both brief
forms as membership aliases (harmless for an interim index; prevents a
citation-style round-trip). Minor doc-reconciliation note (product-settleable,
non-blocking): ADR-056 D2's `brief-<slug>` could be unified to `brief-NNN` for
uniformity; until then the index accepts either.

---

## 2. Committed lead-side reference artifacts + generator

- **`bin/gen-scenario-refs`** — reproducible generator (not hand-maintained).
  Scans `adr/` `pdr/` `briefs/`, emits `scenario-refs/origin-index.txt`, and
  echoes the manifest-derived legal `@bc`/`@service` set to stderr for audit
  (it does NOT project the manifest — decision 1a). Re-run on any ADR/PDR/brief
  add.
- **`scenario-refs/origin-index.txt`** — 112 origin identifiers (53 adr + 29
  pdr + 15 briefs ×(numeric+slug)); header documents provenance + regeneration.
  `adr-056` present (line 62), so the scenarios BC's own dogfood file validates.
- **`bc-manifest.yaml`** — UNCHANGED; already the `@bc`/`@service` reference
  (ADR-056 D10 reconcile landed prior). Cited here as the first bundle input.

**Proof the finalized format validates the real corpus (design proof, lead-side
— NOT BC source execution):** a prototype subclass applying decision 1a
(name-extraction) + 1b (origin-index membership) validated a conformant
`probe.feature` (`@bc:shopsystem-scenarios`, `@origin:adr-056`) exit 0 against
the REAL `bc-manifest.yaml` (dict entries) and the generated
`origin-index.txt`, with `origin_roots=[]` (no `adr/` dir — the BC-side ADR-018
posture). `violations: []`, `exit_code: 0`.

---

## 3. Dispatch spec A (do NOT send) — `shopsystem-scenarios` `request_bugfix`

**Vehicle: `request_bugfix`.** Discriminator: Q1 the capability EXISTS —
`scenarios validate` is installed and runs (verified: it crashes on the real
manifest, so the manifest-reading + origin-resolution behavior is present but
buggy). Q2 no scenario pins the REAL-DATA path — the `lead-vzxd.1` guard
scenarios pin FIXTURE shapes (string-list manifest, `adr-NNN.md` marker files)
only; the structured-manifest name-extraction and origin-index membership are
UNPINNED existing behavior. Q3 behavioral → tighten unpinned behavior =
`request_bugfix` (may carry the new pinning scenarios; PO authors them).

**Contract-surface pre-state citation (ADR-018 D1) for the dispatch text:**
- `frozenset(data.get('bcs'))` at installed `scenarios/validate.py:271` crashes
  `TypeError: unhashable type: 'dict'` on the real `bc-manifest.yaml` dict
  entries (reproduced this session).
- `_origin_resolves` at `validate.py:288` seeks `<ref>.md`; real records are
  `NNN-slug.md`, so `@origin:adr-056` fails `E_UNKNOWN_ORIGIN` (reproduced); a
  BC container has no `adr/` dir (ADR-018), so dir-scan is BC-side non-viable.

**Scope of change (harden for the REAL provisioned reference data):**
1. `_load_manifest`: extract `name` from structured `bcs:`/`services:` dict
   entries; still accept bare-string entries (fixtures); ignore additive keys
   (`status`/`deferred_to`/`remote`/`role`). No crash on the real manifest.
2. New `--origin-index <file>` flag: `_origin_resolves` resolves by membership
   against the provisioned identifier list, in addition to the existing
   `unresolved` sentinel + lead-bead prefix rule; `--origin-root` dir-scan
   retained for fixtures. Missing index file → empty set (graceful, no crash).
3. Graceful errors throughout — a malformed manifest/index yields a clean
   diagnostic, never a traceback.
4. **CUT A VERSIONED RELEASE (ADR-039 — version bump is part of the fix).**
   Pre-state: capability merged to main (`7b6bacc`) but never tagged; latest
   tag is `v0.2.0` and the installed pkg reports `0.2.0` despite already
   carrying `validate`/`create`/`consolidate`. **Cut `v0.3.0`** capturing
   everything since `v0.2.0` (validate + create + consolidate + this
   reference-data hardening) so the lead + `shopsystem-templates` +
   `shopsystem-messaging` (all depend on `scenarios`) can pin a real version.

**Pinning scenarios (PO authors):** structured-manifest name-extraction
validates green; a dict-entry manifest does NOT crash; `--origin-index`
membership resolves `@origin:adr-056` with no `adr/` dir present; a genuinely
unknown origin still fires `E_UNKNOWN_ORIGIN`; malformed inputs yield
diagnostics not tracebacks.

**@scenario_hash conflict enumeration:** this bugfix ADDS pinning scenarios for
previously-unpinned real-data behavior; it does not retire/supersede/contradict
prior BC-side coverage (the fixture-shape guard scenarios remain valid — the
change is additive: it accepts real shapes in ADDITION to fixture shapes). No
conflicting `@scenario_hash` set to retire. (PO/architect re-run the
`grep -r "@scenario_hash" features/` enumeration at authoring time to confirm.)

## 4. Dispatch spec B (do NOT send) — `shopsystem-bc-launcher` `assign_scenarios`

**Vehicle: `assign_scenarios`.** Discriminator Q1: NET-NEW — bc-launcher does
NOT provision a scenario-validation reference bundle today. Contract-surface
pre-state citation (ADR-018 D1): ADR-050 enumerates what the launcher
provisions into a container (BC clone, poured skills furniture, DSN,
agent-vault credentials — P2–P4); a scenario-validation reference bundle is NOT
among them, and `findings/01 §4` records it as net-new downstream work. No
`features/bc-launcher/` scenario pins reference-bundle provisioning. → net-new
→ `assign_scenarios`; PO authors the pinning scenarios.

**Behavior to pin (REFERENCE-BUNDLE PROVISIONING, findings/01 option (c)):** at
launch, bc-launcher provisions the two lead-generated reference artifacts into
each BC container —
- `bc-manifest.yaml` → the container, and points the validator's `--manifest`
  seam at it;
- `scenario-refs/origin-index.txt` → the container, and points the validator's
  `--origin-index` seam at it (the finalized flag from spec A).
The validator's injectable seam (`--manifest` / `--origin-index`) is the SOLE
integration point; the BC never reads cross-repo source (ADR-018). Bundle is
as-fresh-as-launch (re-launch refreshes it; no image rebuild).

**Dependency ordering:** spec B depends on spec A landing the `--origin-index`
flag (so the seam exists to point at). File `bd dep` B-after-A when the beads
are minted.

## 5. DDD linkage (item 5)

The legal-`@bc` index is a PROJECTION of the `lead-bh2m` Domain & Context Map:
"which bounded contexts the domain decomposes into" is a PRODUCT fact whose
first-class home is that map. `bc-manifest.yaml` `bcs:` is the INTERIM curated
source until `lead-bh2m` lands (its provisional entries already carry
`deferred_to: lead-bh2m`). The validator hardening (decision 1a) consumes
`bc-manifest.yaml` today; if `lead-bh2m` repoints the source to the published
context map, the validator seam is UNCHANGED (still a `--manifest` of names) —
the BC is insulated from that ownership decision. This is the explicit
`lead-vzxd` ↔ `lead-bh2m` linkage.

## 6. Sequence to a validate-able real corpus

```
[LANDED this session, lead-side, dagger-spike]
0. bin/gen-scenario-refs + scenario-refs/origin-index.txt committed;
   bc-manifest.yaml is the @bc/@service reference (ADR-005, already landed).
        │
1. Spec A → shopsystem-scenarios (request_bugfix): harden manifest
   name-extraction + --origin-index membership + graceful errors; CUT v0.3.0.
   [PO authors pinning scenarios; router sends]
        │
2. Lead + shopsystem-templates + shopsystem-messaging pin scenarios v0.3.0.
        │
3. Spec B → shopsystem-bc-launcher (assign_scenarios): provision the bundle
   (bc-manifest.yaml + origin-index.txt) at launch; point --manifest /
   --origin-index. [dep: after step 1; PO authors; router sends]
        │
4. Per-BC gated loops now run `scenarios validate` against the provisioned
   bundle → the guard lead-vzxd.1 operates on the REAL corpus → C3 backfill
   (BC self-tagging) becomes checkable → aggregate gate (ADR-047) can go GREEN.
```

Guard is already SOUND (verified). This pipeline supplies the real-shaped
reference data it was missing; steps 1+3 are the two dispatches, step 0 is the
lead-side artifact work done here.

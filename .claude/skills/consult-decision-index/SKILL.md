---
name: consult-decision-index
description: Consult the decision index (L0) and run the coherence gate BEFORE authoring or
  amending any ADR / PDR / brief, so a new decision doesn't duplicate, silently contradict,
  or leave a dangling supersede against the corpus. Use before writing a new adr/*.md,
  pdr/*.md, or briefs/*.md, before changing a decision's status, or when a request may
  already be decided.
---
# Consult the decision index before authoring

**Discipline: no decision authored blind against the corpus.**

This is the authoring-time half of the decision-coherence system shipped by the
`decisions` CLI (`tools/shopsystem-decisions/`). The CI/pour half runs the same
gate mechanically — see [`ci/decisions-gate.sh`](../../../tools/shopsystem-decisions/ci/decisions-gate.sh)
and "How the gate runs in CI" below. This skill is the *human/agent* discipline
that keeps a decision coherent **before** it is committed, so the gate has less
to catch.

## Procedure
1. **Triage against L0.** Read `decision-refs/llms.txt` (or `decisions list adr pdr briefs`)
   for an existing decision that covers or conflicts with the intent. If found,
   amend/supersede it rather than authoring a duplicate.
2. **Read neighbours at L1.** `decisions show <id> --level l1` for each related id
   (L1 = edges + invariants + the `## Decision` body; L2 = the full source file).
3. **Superseding? Write BOTH edges via the tool, never by hand:**
   `decisions supersede <old> --by <new>` (the only writer of `superseded-by`;
   it flips status + adds the back-edge atomically). Superseding an *active*
   target, or leaving an asymmetric edge, is exactly what FC4 (`COH-SG-*`) blocks.
4. **Author WITH frontmatter** (schema §1): required fields + a net-new one-line
   `description` (the L0 triage line). Claiming an invariant (a "parity" /
   "additive" guarantee)? Author `invariants[]`, stamp with `decisions hash`,
   then `decisions baseline <id>` at acceptance — this is what lets FC1
   (`COH-CI-*`) catch the claim later going stale against the scenario surface.
   Forward-looking prose ("not yet …", "deferred", "follow-up")? Tag it with a
   `pending: [{marker, predicate}]` entry so FC2 (`COH-SP-*`) can tell you when
   the awaited thing lands and the prose goes stale.
5. **Gate before commit** — the same three legs CI runs, locally:
   ```
   decisions check adr pdr briefs --lint --aggregate          # schema floor (must pass)
   decisions check adr pdr briefs --mode authoring --aggregate # FC1-FC4 WARNs; read + resolve/accept
   decisions build && git add decision-refs/                   # regenerate + commit projections
   ```
   Or run all three in one shot: `tools/shopsystem-decisions/ci/decisions-gate.sh --mode authoring`.

## How the gate runs in CI
The gate is wired at two surfaces, both driving the **one** `decisions` binary
so local and CI never diverge (ADR-053); the advisory-vs-blocking split is
ADR-047 D3:

- **Authoring / PR / doctor (advisory).** `ci/decisions-gate.sh --mode authoring`
  runs lint (blocking) → `build --check` (blocking) → `check --mode authoring`
  (FC1-FC4 **WARN**, captured as a PR annotation via
  `DECISIONS_ANNOTATION_FILE`, never fails the build). A doctor aggregate check
  `DECISION_COHERENCE` runs the same line.
- **Distribution / DECISIONS.md pour / release reconciliation (blocking).**
  `ci/decisions-gate.sh --mode distribution` runs the same legs but leg 3
  **blocks**: any FC1-FC4 blocking row (`exit 1`) aborts the pour. This is the
  hard boundary a stale "parity" ADR or a dangling supersede cannot cross.

Lint (`COH-LN-*`) and projection drift (`build --check`) block in **both** modes.

## Do not
- Hand-write `superseded-by` (only `decisions supersede`).
- Add a `decision:` frontmatter key (the `## Decision` body section is its one home; `COH-LN-006`).
- Store a disclosure level in `tier` (`tier` is ADR-035 governance only; `COH-LN-007`).
- Hand-edit anything under `decision-refs/` (it is generated; `build --check` will catch drift).

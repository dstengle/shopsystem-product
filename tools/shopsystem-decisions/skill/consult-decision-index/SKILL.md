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

## Procedure
1. Triage against L0: read `decision-refs/llms.txt` (or `decisions list adr pdr briefs`) for an
   existing decision that covers or conflicts with the intent. If found, amend/supersede it.
2. Read neighbours at L1: `decisions show <id> --level l1` for each related id.
3. Superseding? Write BOTH edges via the tool, never by hand: `decisions supersede <old> --by <new>`.
4. Author WITH frontmatter (schema §1): required fields + a net-new one-line `description`.
   Claiming an invariant? Author `invariants[]`, stamp with `decisions hash`, then
   `decisions baseline <id>` at acceptance.
5. Gate before commit: `decisions check adr pdr briefs --lint --aggregate` (must pass), then
   `--mode authoring --aggregate` (read WARNs; resolve or consciously accept), then
   `decisions build` and commit the regenerated `decision-refs/`.

## Do not
- Hand-write `superseded-by` (only `decisions supersede`).
- Add a `decision:` frontmatter key (the `## Decision` body section is its one home).
- Store a disclosure level in `tier` (ADR-035 governance only).
- Hand-edit anything under `decision-refs/`.

---
type: implementation-guidance
id: guidance-feat-implementation-good-shopsystem-product
status: written
version: 1
initiative: ../initiatives/init-implementation-process.md
feature: ../features/feat-implementation-good.md
context: shopsystem-product
scenarios: ["@hash:d11bce62c8e2", "@hash:c4c48c7eef06", "@hash:ab646950e73e", "@hash:9dd7cbd13419", "@hash:bbccc3a1765c", "@hash:a9c2dc030958", "@hash:c78d764ecf61"]
owner: lead-solutions-architect
created: 2026-09-17
updated: 2026-09-17
---

# Implementation guidance: feat-implementation-good for shopsystem-product

All seven scenarios of feat-implementation-good (v6), assigned to
shopsystem-product — the only owner Contributors names — on
2026-09-17 under init-implementation-process (v4), session one.
Historical record; binds nothing after it.

## What changes

1. **`principle-set` typedef `scope` field**
   (basis/artifacts/principle-set.md): its closed enumeration
   (`working`, `architecture`, `experience`) has no value for one
   engineering discipline's definition of good. Add a fourth value
   (e.g. `engineering`) through the small-change process, as prior
   typedef amendments were made — a corpus-form extension, no ADR.
   Serves `@hash:d11bce62c8e2`.
2. **One new `principle-set` instance**, the definition of good for
   implementation engineering, authored at that scope through
   `principle-set-authoring` (draft, `cold-reviewer` screen, owner
   approval), in the four-part form the two existing sets already
   use. That typedef already bars naming a tool, step, or technique
   as good and bars a rationale citing operational history —
   scenarios 2 and 3's bar; draft to it, write no new rule. Serves
   `@hash:d11bce62c8e2`, `@hash:c4c48c7eef06`, `@hash:ab646950e73e`.
3. **Two new `role-definition` instances** under `basis/roles/`,
   generic, not lead-prefixed, since Contributors names every
   implementing shop: a maker role and a checking role. Each names
   the new principle set as the source its Accountabilities draw from
   (`@hash:c78d764ecf61`). The maker's Exclusive domain is producing
   the implementation; its Accountabilities name no checking of its
   own work, naming the checking role instead (`@hash:a9c2dc030958`).
   The checking role's Exclusive domain is the pass/fail verdict; its
   Accountabilities require exactly the evidence
   adr-2026-09-16-scenario-evidence-form fixes — a presented
   executable test's pass/fail, or, absent one, its own mark, never
   the maker's declaration (`@hash:bbccc3a1765c`). No accountability
   sits on both (`@hash:9dd7cbd13419`).

## References

- init-implementation-process (v4, active); feat-implementation-good
  (v6, checked), hashes per frontmatter.
- adr-2026-09-16-scenario-evidence-form (v1, recorded) — the
  checking role's evidence bar. Contracts: none.
- Read: principle-set typedef (v6) with guideline and fitness set;
  principles.md (v12); architecture-principles.md (v7);
  role-definition typedef (v5); principle-set-authoring (v9);
  small-change (v7).
- Sibling feat-implementation-process (v3, checked), assigned in
  parallel, complementary by the initiative's own order-flip.

## What not to do

- Do not fold the definition into an existing role's own prompt or
  write it as prose guidance or a fitness set instead of a principle
  set: one stated definition, one home (`single-source-of-truth`,
  `external-standards-first`).
- Do not let either prompt restate a rule the principle set states:
  Accountabilities point to it by name (`governed-context`).
- Do not give the checking role a different evidence bar than
  adr-2026-09-16-scenario-evidence-form fixes, and do not let the
  maker mark its own non-executable scenario passed: that decision
  stands recorded, and this feature's scenario rides on its hash.
- Do not touch feat-implementation-process's scope — process,
  permission, proof execution: session two's content, by design.
- Do not create a Bounded Context contract or context record for
  either role: the initiative's no-gos bar it.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-17 | update | Written by the lead-solutions-architect role at scenario-assignment's assign step. Self-check against the implementation-guidance fitness set: scenario 1 pass — each statement names a typedef field, principle-set instance, or role-definition instance, none a context internal; scenario 2 pass — every scenario cited by hash, every definition by name and version, none restated; scenario 3 pass — the typedef amendment, the new set, and the two roles let the shop begin unaided; scenario 4 pass — each entry names its reason; scenario 5 pass — initiative, feature, context, and all seven hashes named; scenario 6 pass — `wc -w` counts 600, the target. Status written; not sent. |

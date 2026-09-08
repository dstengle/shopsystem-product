---
type: implementation-guidance
id: guidance-feat-role-decisions-shopsystem-product
status: written
version: 1
initiative: ../initiatives/init-role-decisions.md
feature: ../features/feat-role-decisions.md
context: shopsystem-product
scenarios: ["@hash:aba312f2b1ae", "@hash:d24c8e22069d", "@hash:74a11c38f2ce", "@hash:a66e2bd3cd35", "@hash:2fef03c8cc09", "@hash:c15c4d3bdff0", "@hash:3ffc45cf66b9", "@hash:a7aa73a0b41d"]
owner: lead-solutions-architect
created: 2026-09-06
updated: 2026-09-08
---

# Implementation guidance: feat-role-decisions for shopsystem-product

For the eight scenarios of feat-role-decisions (v5) assigned to
shopsystem-product — the lead shop itself — on 2026-09-06 under
init-role-decisions (v10); the hashes are the frontmatter's
`scenarios` list. Historical record; binds nothing after it.

## What changes

No contract; adr-2026-09-05-role-offer (v3) the design decision. Order:
typedef, instances, renders (C1–C7).

1. **New data type, `basis/types/`** (data-type typedef v3): one field
   per offer part per the ADR's §2, a bet-dependent field holding a
   decision-record id or `none`, an out-of-domain part `none` with a
   reason (C1, C5). Designer screens field names. Serves
   `@hash:74a11c38f2ce`, `@hash:a66e2bd3cd35`, `@hash:2fef03c8cc09`,
   `@hash:c15c4d3bdff0`, `@hash:3ffc45cf66b9`.
2. **role-definition typedef (v3)** gains a required section after
   Exclusive domain: decisions owned and offered unasked, never a step
   (C2); its fitness set (v2) gains one scenario judging it. Serves
   `@hash:aba312f2b1ae`, `@hash:d24c8e22069d`.
3. **Four role definitions**, after item 2 (lead-pm, lead-po,
   lead-solutions-architect, lead-product-designer): section drawn from
   each's Exclusive domain and Decision rights; re-render via
   `compile_role.py <role.md> --agent .claude/agents/<name>.md`,
   `--check` `ok` for all four. Serves `@hash:aba312f2b1ae`,
   `@hash:d24c8e22069d`, `@hash:a7aa73a0b41d`.
4. **initiative-check (v7):** both attach steps gain item 1's type
   beside `initiative`; prompts cut to one sentence (C3); `screen`
   unchanged (C6). Re-render via `compile_process.py`. Serves
   `@hash:74a11c38f2ce`, `@hash:a66e2bd3cd35`, `@hash:2fef03c8cc09`,
   `@hash:3ffc45cf66b9`, `@hash:a7aa73a0b41d`.
5. **initiative typedef §4 and fitness v4** (authority-owned): §4
   references item 1's type per role's verdict, names the Document
   History as the offer's home (cap soft, 20%); fitness scenario 5
   judges each offer by the type's parts. Serves `@hash:2fef03c8cc09`,
   `@hash:a66e2bd3cd35`, `@hash:3ffc45cf66b9`, `@hash:c15c4d3bdff0`.
6. **Not in this assignment:** the pre-bet route into adr-authoring
   (D3); the PM/PO observations for `@hash:a7aa73a0b41d` come from
   existing steps, no amendment.
7. **Done:** all four definitions carry the section, `--check` reads
   `ok` four times, the skill is byte-equal, the lint clean, one
   observation per role recorded.

## References

- Initiative: init-role-decisions (v10, active). Feature:
  feat-role-decisions (v5, checked), constraints C1–C7; scenarios per
  the frontmatter list.
- Decisions: adr-2026-09-05-role-offer (v3, checked);
  pdr-2026-09-06-bet-role-decisions (the bet).
- Contracts: none exist on this branch.
- Definitions read: role-definition typedef v3 (fitness v2); initiative
  typedef v10 (fitness v4); initiative-check v7; data-type typedef v3;
  artifact-typedef typedef v3; adr-authoring v2; discovery-conversation
  v11; feature-authoring v6; role-rendering v7; skill-rendering v7;
  reconcile-and-close v4; the four role definitions (versions in item
  3).
- Tools: `compile_role.py`, `compile_process.py`, `lint_basis.py`.
- Touch-points: feat-roles-availability (v6) `@hash:d707d4311bdf`,
  feat-skills-availability (v8) `@hash:26f78a3ca4a6` — a
  hand-diverged-render reconcile.

## What not to do

- Do not restate the offer's parts in a prompt, role section, or §4:
  the type is their one home (`single-source-of-truth`; C1).
- Do not add the section before the typedef names it, or hand-edit a
  rendered agent or skill (`bidirectional-conformance`; C2, C6).
- Do not write a step name or "when" into the section: no-sequencing
  rule.
- Do not repair a missing part with an instruction at the step: fix
  the role's definition (`actor-neutral-discipline`; C3).
- Do not add the pre-bet route into initiative-check here: D3 bounded,
  not decided (C5).
- Do not split the 500-word cap or move the offer's home from the
  Document History: owner's ruling (C4).
- Do not add Writing rules or Fitness scenarios to either typedef here:
  hand-written stays (feat-typedef-rendering's scope).
- Do not report a missing part only as "uncovered": name the criterion
  (C6).
- Do not make the decisions field prose (C5).
- Do not extend the type or section to a Bounded Context shop
  (`contracts-between-contexts`; C7).

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-06 | update | Written by the lead-solutions-architect role at scenario-assignment's assign step. Self-check v1: all five fitness scenarios pass. Status written; not sent. |
| 2 | 2026-09-08 | update | Rewritten to the plain-voice rule under feat-plain-voice-rest (`@hash:8b1d5c3f9e26`): prose cut, v1 condensed, References unchanged in substance. Self-check v2: scenarios 1–5 hold; scenario 6 pass, under the 600-word target. Made by the lead-solutions-architect role. |

---
type: artifact-typedef
id: principle-set-typedef
defines: principle-set
owner: product-authority
status: approved
approved: 2026-08-22
version: 5
created: 2026-08-19
updated: 2026-08-23
ancestry: [definition, principle-set]
---

# Artifact type: principle-set

## Identity and ancestry

- **Type:** `principle-set` — the document holding the standing rules
  about how we work. Hand-approved by the owner; everything else in the
  system traces to it.
- **Produced by:** the principle-set authoring process
  ([`../processes/principle-set-authoring.md`](../processes/principle-set-authoring.md));
  amended only by the owner's decision.
  **Consumed by:** every definition author and reviewer; the fitness
  screen's judge.

## Required frontmatter

`type: principle-set`, `id`, `scope` (the level the set governs and whose
context it loads into: `working` — how every activity is performed, loads
everywhere — or `architecture` — how the system is designed, loads where
design work happens), `owner`, `status`, `created`, `updated`.

## Rules

- Content in an undefined format never enters a set as-is: it is source
  material for a rewrite through this typedef, or it retires.
- Where a principle in one set applies another set's principle to its own
  level, it declares the lineage (`derives-from`) rather than restating
  the rule as a second authority.
- A rationale MUST use generic examples and MUST NOT reference the
  product's operational history — other artifacts, issues, incidents,
  decision records, counts; it MAY cite well-known external references as
  support.

## Required sections

1. **What a good principle looks like** — the opening self-definition:
   the four parts (name, statement, rationale, implications) and the
   tests a good principle passes. The document obeys its own first rule
   by defining good before presenting instances.
2. **The principles** — each: a heading with name and kebab-case slug,
   then **Statement** (the rule; carries the only normative keywords —
   MUST/SHOULD/MAY per BCP 14 — and is yes/no testable; one or more
   sentences, and a statement with more than one obligation presents
   one obligation per bullet), **Rationale**
   (the failure prevented, shown as a generic example; well-known
   external sources may support it), **Implications**
   (the price tag: one implication per bullet, each derivable from the
   statement and naming the actor who absorbs the change; never a new
   obligation).
3. **Fitness screen** — a table applying the opening's tests to every
   principle, including the two mechanical/judged rows: normative
   keywords in statements only; implications derivable and actor-named.

## Commitment (Definition of Done)

A principle set is done when every principle passes every screen row and
the screen covers every principle. **Consequence on failure:** the
failing principle is repaired or removed before the set is citable.

## Sources

TOGAF architecture principles (Name/Statement/Rationale/Implications);
BCP 14 (RFC 2119/8174 keywords); the screen composes Spool (helps you
say no), Rumelt (not fluff, not a goal in disguise), and Lencioni (not
permission-to-play); Deming grounds the first principle's rationale, not
a screen row.

## Derived review checklist

- Opening self-definition present before any principle. *(§Required sections 1)*
- BCP 14 capitals outside statements appear only in the opening's
  keyword-definition sentence (mentions, not uses) — mechanical grep with
  that single exemption. *(§Required sections 1–2)*
- Each implication traceable to a statement clause and actor-named —
  judged. *(§Required sections 2)*
- Screen table has a column per principle and rows for every test.
  *(§Required sections 3)*
- Multi-obligation statements and implications carry one obligation or
  implication per bullet — judged. *(§Required sections 2)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-19 | update | Authored (seed layer). |
| 1 | 2026-08-22 | state | draft → approved by the owner. |
| 2 | 2026-08-23 | update | Produced-by names the principle-set-authoring process by owner direction. |
| 3 | 2026-08-23 | update | Rationale rule added: generic examples, never the product's operational history. |
| 4 | 2026-08-23 | update | Form rules added: one obligation or implication per bullet; checklist row added. |
| 5 | 2026-08-23 | update | Owner direction: decision-ledger references removed — changes stand on their own; history entries and text no longer cite numbered decisions. |

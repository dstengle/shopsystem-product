---
type: artifact-typedef
id: principle-set-typedef
defines: principle-set
owner: product-authority
status: approved
approved: 2026-08-22
created: 2026-08-19
updated: 2026-08-20
ancestry: [definition, principle-set]
---

# Artifact type: principle-set

## Identity and ancestry

- **Type:** `principle-set` — the document holding the standing rules
  about how we work. Hand-approved by the owner; everything else in the
  system traces to it.
- **Produced by:** seed drafting; amended only by the owner's ruling.
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

## Required sections

1. **What a good principle looks like** — the opening self-definition:
   the four parts (name, statement, rationale, implications) and the
   tests a good principle passes. The document obeys its own first rule
   by defining good before presenting instances.
2. **The principles** — each: a heading with name and kebab-case slug,
   then **Statement** (the rule; carries the only normative keywords —
   MUST/SHOULD/MAY per BCP 14 — and is yes/no testable), **Rationale**
   (the failure prevented, with evidence where held), **Implications**
   (the price tag: derivable from the statement, each naming the actor
   who absorbs the change; never a new obligation).
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

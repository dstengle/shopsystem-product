---
type: fitness-set
id: principle-set-fitness
owner: product-authority
status: approved
approved: 2026-08-23
created: 2026-08-22
updated: 2026-08-23
target-type: principle-set
judged: true
executable: false
judged-by: cold-reviewer
---

# Fitness set: principle-set

These scenarios are evaluated by the `cold-reviewer` role, never executed
— no step definitions exist or will exist. The judge's model and prompt
version are recorded with each round verdict. The mapping table at the
end compiles each Then into the judge-rubric assertion the reviewer
scores. The scenarios project the set's own opening tests (the
self-definition the typedef requires) and the
[principle-set guideline](../guidelines/principle-set.md)'s rules into a
judge's rubric.

## Scenarios

Scenario 1: good is defined before any instance, and only the four parts appear
  Given the principle set read top to bottom
  When the reader reaches the first principle
  Then the opening has already defined the four parts and the tests a
  good principle passes
  And each principle carries exactly a slugged name, a statement, a
  rationale, and implications — nothing else
  And every cross-reference to a principle uses its slug, never a number

Scenario 2: the statement decides alone
  Given any principle's statement and one concrete piece of work
  When a reviewer holds the work against the statement alone
  Then the reviewer can answer yes or no without reading the rationale
  or the implications

Scenario 3: the rationale shows a generic failure
  Given any principle's rationale
  When its evidence is checked
  Then it names the failure the rule prevents with a generic example,
  references no operational history of the product — artifacts, issues,
  incidents, rulings, or counts — and cites, at most, well-known
  external references as support

Scenario 4: implications are a derivable price tag
  Given each implication
  When it is traced back to its principle's statement
  Then it names the actor who absorbs the change, follows from a
  statement clause, and adds no obligation the statement does not carry

Scenario 5: the screen covers the set
  Given the set's fitness screen table
  When it is compared against the principles and the opening's tests
  Then every principle has a column, every test has a row, and every
  claimed pass is one the judge can reproduce

Scenario 6: each principle rejects something
  Given any principle
  When asked what work it rules out
  Then it rejects work this shop would otherwise do, and the opposite
  rule is one an honest shop could adopt

## Compile mapping (each Then/And → one judge-rubric assertion)

| Scenario Then | Judge-rubric assertion (established format, tool chosen later) |
|---|---|
| 1 (Then) — good defined first | "Does a self-definition (the four parts and the tests) appear before the first principle? Yes/no; cite the heading." |
| 1 (And) — four parts only | "For each principle, list any content outside name, statement, rationale, implications. Empty list = pass." |
| 1 (And) — slug citations | "List every cross-reference to a principle made by number or position instead of slug. Empty list = pass." |
| 2 — statement decides alone | "For each statement: could you accept or reject a concrete piece of work from the statement alone? Cite any statement that needs its rationale to decide." |
| 3 — rationale shows a generic failure | "For each rationale, quote the generic failure example. Any reference to the product's operational history — an artifact, issue, incident, ruling, or count — = fail, cite it. Any external reference cited must be a well-known published source, standard, or named law." |
| 4 — implications derivable, actor-named | "For each implication, name the actor and the statement clause it follows from. Any implication with no actor or no clause = fail, cite it." |
| 5 — screen covers the set | "Is there a column per principle and a row per test? Is any claimed pass one you cannot reproduce? Cite mismatches; none = pass." |
| 6 — rejects something | "For each principle, state the work it rejects and the opposite rule. If it rejects nothing we would otherwise do, or no honest shop could adopt the opposite, = fail." |

## Sources

Gherkin syntax (the readable G/W/T frame — syntax only, no runner);
G-Eval–style rubric decomposition and promptfoo's llm-rubric assertion
form for the mapping table; the tests themselves compose TOGAF
(statement quality), Spool (helps you say no), Lencioni (not
permission-to-play), and the shop's own screen rows, per the
principle-set typedef.

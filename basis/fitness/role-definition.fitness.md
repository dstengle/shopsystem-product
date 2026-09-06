---
type: fitness-set
id: role-definition-fitness
owner: product-authority
status: approved
approved: 2026-08-23
version: 3
created: 2026-08-23
updated: 2026-09-06
target-type: role-definition
judged: true
executable: false
judged-by: cold-reviewer
---

# Fitness set: role-definition

These scenarios are evaluated by the `cold-reviewer` role, never
executed. The mapping table at the end compiles each Then into the
judge-rubric assertion the reviewer scores. The scenarios project the
[role-definition typedef](../artifacts/role-definition.md)'s
requirements and the
[role-definition guideline](../guidelines/role-definition.md)'s rules
into a judge's rubric.

## Scenarios

Scenario 1: the role instantiates from the file alone
  Given the role file and a runtime that knows only the typedef
  When the role is instantiated
  Then the functional contract keys — name, description, tools,
  maxTurns — are present and first in the frontmatter
  And nothing needed to fill the role lives outside the file
  And no actor kind is committed to, unless the role is an owner's
  role a person must hold, stated once as the role's authority

Scenario 2: the role says who and what for, never when
  Given every sentence of the role definition
  When each is checked for sequencing
  Then none says when the role acts, what step precedes it, or what
  follows it — the processes that name the role own its sequencing

Scenario 3: exactly one exclusive domain, phrased as a decision
  Given the role's exclusive-domain claim
  When it is counted and parsed
  Then exactly one exists and it names a decision only this role may
  make

Scenario 4: accountabilities are answerable
  Given the accountabilities section after an imagined run
  When each bullet is checked
  Then the section holds 4–6 bullets and a reviewer can say of each
  whether the role delivered it — an output or a judgment, never a
  character trait

Scenario 5: the capability contract enforces the stance
  Given each stance claim in the prose
  When it is compared to the frontmatter's tools and caps
  Then every mechanically enforceable claim is enforced — read-only
  roles carry read-only tools, drift-prone roles carry a turn cap —
  and the prose promises nothing the contract permits violating

Scenario 6: the decisions owned are named and offered on
  Given the Decisions owned section, read against the role's
  exclusive domain and decision rights
  When each decision it names is checked against them
  Then every decision, or part of a decision, it names falls in the
  exclusive domain or a decision right, and none the domain holds is
  left to another role's instruction
  And the section states that the role offers complete information
  on them, unasked, when it attaches to or acts on an initiative
  And it references the role-offer data type for the offer's shape
  and restates none of its parts, and names no step

## Compile mapping (each Then/And → one judge-rubric assertion)

| Scenario Then | Judge-rubric assertion |
|---|---|
| 1 (Then) — functional keys first | "Are name, description, tools, maxTurns present and before the identity keys? Yes/no; cite the frontmatter." |
| 1 (And) — self-contained | "Name anything required to fill the role that the file does not carry. Empty list = pass." |
| 1 (And) — actor-neutral | "Quote any actor-kind commitment. A single owner's-role statement of authority = pass; working instructions tied to an actor kind = fail." |
| 2 — no sequencing | "Quote every sentence that says when the role acts. Empty list = pass." |
| 3 — one exclusive domain | "Count the exclusive-domain claims and quote the decision each names. Exactly one, decision-phrased = pass." |
| 4 — answerable accountabilities | "For each bullet: could you verify after a run that the role delivered it? 4–6 bullets, all verifiable = pass; cite any character-trait bullet." |
| 5 — contract enforces stance | "For each stance claim, name the frontmatter key that enforces it or state that no mechanical enforcement exists. Any enforceable-but-unenforced claim = fail, cite it." |
| 6 (Then) — decisions in the domain | "For each decision the Decisions owned section names, cite the exclusive-domain claim or the decision right it falls under; cite any decision the domain or rights hold that the section leaves unnamed. All cited, none unnamed = pass." |
| 6 (And) — the offer stated | "Quote the sentence stating that the role offers complete information on those decisions unasked when it attaches to or acts on an initiative. Present = pass." |
| 6 (And) — shape referenced, no step | "Does the section reference the role-offer data type? Quote any offer part it restates and any step or moment it names. Referenced, both lists empty = pass." |

## Sources

Gherkin syntax (readable G/W/T frame — syntax only, no runner);
G-Eval–style rubric decomposition for the mapping table; the tests
project the role-definition typedef's checklist and the guideline's
rules, per the definition-chain shape the principle-set chain
established.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-23 | update | Authored as the role-definition meta-chain's fitness set. |
| 1 | 2026-08-23 | state | draft → approved by the owner, with the exemplar screens' findings accepted as valid and their repairs directed. |
| 2 | 2026-08-25 | update | Owner direction: a near-synonym of "role" retired and banned. |
| 3 | 2026-09-06 | update | Under init-role-decisions / feat-role-decisions on the authority's bet of 2026-09-06 (the feature's constraint C2): scenario 6 added, projecting the role-definition typedef's (v4) Decisions owned section — every decision named falls in the exclusive domain or a decision right and none the domain holds is left unnamed, the offer stated, the role-offer type referenced with no part restated and no step named — with three mapping rows. Hand-amended under the artifact-typedef typedef's rule for a type whose fitness set is not produced. Maker's evaluation against the fitness-set typedef's checklist: frontmatter guardrails unchanged; not under features/; every Then and And of scenario 6 in the mapping table, each falsifiable — a judge shown a section naming a decision outside the rights, omitting the offer sentence, listing the parts, or naming a step can point at it. Made by the lead-solutions-architect role; the owner's approval of the amendment is pending. |

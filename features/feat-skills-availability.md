---
type: feature
id: feat-skills-availability
name: Skills availability
status: assigned
version: 8
initiative: ../initiatives/init-skills-availability.md
owner: lead-po
created: 2026-09-02
updated: 2026-09-02
---

# Feature: Skills availability

## Feature

Feature: Skills availability
  An agent of the lead shop performing an activity that operates
  through a process definition
  can load the approved definition of that activity at its point of
  work, from an approved source that is itself maintained by a defined
  process with its own check,
  so that the shop stops drifting from its approved definitions:
  the agent operates from the approved definition of its activity.

## Contributors

Owning shop, per scenario — from the initiative's Decomposition
section, which names no Bounded Context: source definitions, the
generator, and the delivery point all sit in the lead shop's own tree.

- *an approved process definition is loadable at the point of work* — shopsystem-product (the lead shop)
- *an agent loads the skill for its activity at the point of work* — shopsystem-product (the lead shop)
- *a definition that does not stand approved yields no loadable skill* — shopsystem-product (the lead shop)
- *divergence between a loadable skill and its approved definition is detected* — shopsystem-product (the lead shop)
- *an approved process without a loadable skill is reported* — shopsystem-product (the lead shop)
- *a hand-diverged skill is reconciled* — shopsystem-product (the lead shop)
- *the check passes clean when every approved process is available* — shopsystem-product (the lead shop)

No usability acceptance criteria and no accessibility criteria are due for these scenarios: the initiative's For whom section names no interaction type — the outcome is consumed inside the executing agent's context load; no core task carries it. (designer, 2026-09-02)

Non-functional constraints: the decomposition names none for this feature. (architect, 2026-09-02)

## Interaction types

None — the outcome is consumed inside the executing agent's context
load; no core task carries it (the initiative's For whom section).

## Scenarios

```gherkin
Feature: Skills availability
  An agent of the lead shop performing an activity that operates
  through a process definition
  can load the approved definition of that activity at its point of
  work, from an approved source that is itself maintained by a defined
  process with its own check,
  so that the shop stops drifting from its approved definitions:
  the agent operates from the approved definition of its activity.

  @bounded-context:shopsystem-product @feature:feat-skills-availability @hash:4d84f279b2c1
  Scenario: an approved process definition is loadable at the point of work
    Given a process definition that stands approved
    When the skill-rendering process runs
    Then a loadable skill for that definition exists at the agent's load point, matching the loadable form of its approved definition

  @bounded-context:shopsystem-product @feature:feat-skills-availability @hash:b3ac2b4f4dca
  Scenario: an agent loads the skill for its activity at the point of work
    Given a task to write a feature artifact
    When the agent begins the feature-authoring activity
    Then the skill rendered from the feature-authoring process definition is loaded

  @bounded-context:shopsystem-product @feature:feat-skills-availability @hash:7e5f2f1efd81
  Scenario: a definition that does not stand approved yields no loadable skill
    Given a process definition that does not stand approved
    When the skill-rendering process runs
    Then no skill for that definition is loadable at the agent's load point

  @bounded-context:shopsystem-product @feature:feat-skills-availability @hash:bcfab497fa9f
  Scenario: divergence between a loadable skill and its approved definition is detected
    Given a loadable skill whose text differs from the loadable form of its approved definition
    When the check runs
    Then the check reports the divergence, naming the process whose skill diverged

  @bounded-context:shopsystem-product @feature:feat-skills-availability @hash:4a07b9bbc96d
  Scenario: an approved process without a loadable skill is reported
    Given an approved process definition with no loadable skill at the agent's load point
    When the check runs
    Then the check reports that process as not available to the agent

  @bounded-context:shopsystem-product @feature:feat-skills-availability @hash:26f78a3ca4a6
  Scenario: a hand-diverged skill is reconciled
    Given a loadable skill edited by hand away from the loadable form of its approved definition
    When the skill-rendering process runs
    Then the skill available to the agent matches the loadable form of its approved definition

  @bounded-context:shopsystem-product @feature:feat-skills-availability @hash:4899d4bba6ad
  Scenario: the check passes clean when every approved process is available
    Given every approved process definition with a loadable skill at the agent's load point matching its loadable form
    When the check runs
    Then the check reports no divergence and no missing skill
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| A loadable skill diverged from the loadable form of its approved definition | the framing ("we are already drifting away from the principles") | Scenario: divergence between a loadable skill and its approved definition is detected |
| The one reachable skill standing hand-diverged from its source | the initiative's For whom section ("that one hand-diverged from its source") | Scenario: a hand-diverged skill is reconciled |
| An approved process the agent cannot load | the framing ("cannot be loaded by the agent performing the activity") | Scenario: an approved process without a loadable skill is reported |
| A skill exists but sits outside the agent's load point | the framing ("not placed where an agent would make use of them") | Scenario: an approved process without a loadable skill is reported — a skill not at the load point is not loadable at the point of work |
| A definition that does not stand approved | the framing's outcome ("the approved definition", "an approved source") | Scenario: a definition that does not stand approved yields no loadable skill |
| An agent begins an activity whose process has a skill | the framing's outcome ("operates from the approved definition of that activity, loaded at its point of work") | Scenario: an agent loads the skill for its activity at the point of work |
| Importing skills from the frozen corpus (the 38-skill plan) | the initiative's Appetite | Out of scope: the authority ruled it out; migration stays demand-pull and lands through what this feature makes available |
| Delivering guidelines into authoring contexts | the initiative's Appetite | Out of scope: the observed gap is filed separately (lead-m2o7h) |
| Role definitions | the initiative's Appetite | Out of scope: the authority excepted them, beyond any part that is itself skill-shaped |
| Retrieval, relevance, or knowledge-graph work | the initiative's Appetite | Out of scope: parked as premature (lead-jwsl1) |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-02 | update | Authored by the PO role alone in the feature-authoring draft step, from init-skills-availability's Framing and For whom sections; six scenarios, all owned by the lead shop per the initiative's Decomposition; interaction types none per its For whom; the first feature in the repository. |
| 2 | 2026-09-02 | review | PO output check round 1 (judge: claude-fable-5 / screen prompt v6): findings — two Edges rows mis-sourced to the framing (confident, repaired); "the rendering process" pre-naming an undefined process (wobbly; repaired to framing terms); the narrative's so-that tail carrying measure language (wobbly; closed on the framing's outcome). |
| 3 | 2026-09-02 | review | Round 2 (judge: claude-fable-5 / screen prompt v6): findings — the matching target "its definition's rendering" an undefined intermediary (repaired to "the loadable form of its approved definition" throughout); the framing's wrong-place case without an Edges row (row added with subsumption stated). |
| 4 | 2026-09-02 | review | Round 3, the cap (judge: claude-fable-5 / screen prompt v6): findings — "loadable form of its approved definition" not decidable from the check's inputs (wobbly); the duplicated Feature narrative (uncovered; answered by the typedef, which accepts the repeat with the block as source). |
| 4 | 2026-09-02 | state | `draft` → `returned`: the PM role's decision at the cap — fail on "each scenario is one observable behavior"; reasons, in the PM's words: "if the behavior is too vague it can't constitute a contract … there is very little for the implementation to go on in terms of even validating." Directed repairs for the re-author pass: the When actor named as the skill-rendering process; an explicit consumption scenario added; the narrative synced to the initiative's amended outcome ("from an approved source"); architecture and UX aspects of the vagueness deferred to other initiatives by the PM's ruling. |
| 5 | 2026-09-02 | update | Re-authored in place per the returned state entry's directed repairs: narrative synced to the amended framing; the When actor named as the skill-rendering process; the consumption scenario added; Edges synced. Resubmitted draft. |
| 6 | 2026-09-02 | review | Resubmission check round 1 (judge: claude-fable-5 / screen prompt v6): findings — the consumption scenario's Edges row sourced to a check-run event, re-sourced to the framing's outcome; "prepares to write the artifact" not one discrete event, the When sharpened to "begins the feature-authoring activity". |
| 7 | 2026-09-02 | review | Round 2 (judge: claude-fable-5 / screen prompt v6): clean. |
| 7 | 2026-09-02 | state | `draft` → `checked`: the PM role's pass on the clean round-2 screen. First pass — the linked initiative set `active` by this step, the initiative typedef's writer. "Loadable form" gets its glossary home with the skill-rendering process definition (bead lead-36apr). |
| 8 | 2026-09-02 | state | `checked` → `assigned`: the scenario-assignment record step. One assignment entry — context shopsystem-product (the lead shop), scenarios @hash:4d84f279b2c1, @hash:b3ac2b4f4dca, @hash:7e5f2f1efd81, @hash:bcfab497fa9f, @hash:4a07b9bbc96d, @hash:26f78a3ca4a6, @hash:4899d4bba6ad. Pre-state read: the initiative's Decomposition ruling — no Bounded Context touched; source definitions, the generator, and the delivery point all in the lead shop's tree; the feature repository swept in full — one artifact, this feature, no conflict; no BC contract in the pre-state — the decomposition names no context whose contract bears on these behaviors. Sent: none — the owning shop is the lead shop itself; the freeze bars dispatch and no Bounded Context exists to receive; gap filed as lead-ki66p. |

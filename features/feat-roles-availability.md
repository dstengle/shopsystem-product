---
type: feature
id: feat-roles-availability
name: Roles availability
status: assigned
version: 6
initiative: ../initiatives/init-roles-availability.md
owner: lead-po
created: 2026-09-03
updated: 2026-09-03
---

# Feature: Roles availability

## Feature

Feature: Roles availability
  An agent of the lead shop filling a named role in a process step
  can load the approved definition of that role at its point of work,
  from an approved source that is itself maintained by a defined
  process with its own check,
  so that no role the agent runtime instantiates comes from an
  unapproved source: the agent operates from the approved definition
  of its role.

## Contributors

Owning shop, per scenario — from the initiative's Decomposition
section, which names no Bounded Context: the source definitions, the
render, and the load point all sit in the lead shop's own tree.

- *an approved role definition is available at the point of work* — shopsystem-product (the lead shop)
- *an agent fills a role from the approved source at the point of work* — shopsystem-product (the lead shop)
- *a role definition that does not stand approved yields no available role* — shopsystem-product (the lead shop)
- *a role in the approved source not current with its approved definition is detected* — shopsystem-product (the lead shop)
- *an approved role definition with no available role is reported* — shopsystem-product (the lead shop)
- *a role available to the agent runtime that traces to no approved definition is reported* — shopsystem-product (the lead shop)
- *a role not current with its approved definition is reconciled* — shopsystem-product (the lead shop)
- *the check passes clean when every approved role is available* — shopsystem-product (the lead shop)

No usability acceptance criteria and no accessibility criteria are due for these scenarios: the initiative's For whom section names no interaction type — the outcome is consumed inside the agent runtime's instantiation of the role, no core task on the core-task list carries it, and the rendered role is outside `agent-is-a-user`'s closed set of agent-facing interfaces; no failure or boundary case follows for the Edges table. (designer, 2026-09-03)

Non-functional constraints: the decomposition names none for this feature. (architect, 2026-09-03)

## Interaction types

None — the outcome is consumed inside the agent runtime's
instantiation of the role; no core task carries it (the initiative's
For whom section).

## Scenarios

```gherkin
Feature: Roles availability
  An agent of the lead shop filling a named role in a process step
  can load the approved definition of that role at its point of work,
  from an approved source that is itself maintained by a defined
  process with its own check,
  so that no role the agent runtime instantiates comes from an
  unapproved source: the agent operates from the approved definition
  of its role.

  @bounded-context:shopsystem-product @feature:feat-roles-availability @hash:ce98da2b6467
  Scenario: an approved role definition is available at the point of work
    Given a role definition that stands approved
    When the process maintaining the approved source runs
    Then that role is available to the agent runtime from the approved source, current with its approved definition

  @bounded-context:shopsystem-product @feature:feat-roles-availability @hash:cb8d69b7d24e
  Scenario: an agent fills a role from the approved source at the point of work
    Given a process step that names the lead-po role
    When the agent runtime instantiates the role for that step
    Then the role the agent runtime instantiates for that step is loaded from the approved source and is current with the approved definition of lead-po

  @bounded-context:shopsystem-product @feature:feat-roles-availability @hash:c69e5a0eef5d
  Scenario: a role definition that does not stand approved yields no available role
    Given a role definition that does not stand approved
    When the process maintaining the approved source runs
    Then no role from that definition is available to the agent runtime

  @bounded-context:shopsystem-product @feature:feat-roles-availability @hash:1df06aa89e36
  Scenario: a role in the approved source not current with its approved definition is detected
    Given a role in the approved source that is not current with its approved definition
    When the maintaining process's check runs
    Then the check reports the divergence, naming the role

  @bounded-context:shopsystem-product @feature:feat-roles-availability @hash:e0d4e526c948
  Scenario: an approved role definition with no available role is reported
    Given an approved role definition with no role available to the agent runtime
    When the maintaining process's check runs
    Then the check reports that role as not available to the agent runtime

  @bounded-context:shopsystem-product @feature:feat-roles-availability @hash:9d04a8d0a3b9
  Scenario: a role available to the agent runtime that traces to no approved definition is reported
    Given a role available to the agent runtime that no approved role definition is the source of
    When the maintaining process's check runs
    Then the check reports that role as having no approved definition

  @bounded-context:shopsystem-product @feature:feat-roles-availability @hash:d707d4311bdf
  Scenario: a role not current with its approved definition is reconciled
    Given a role in the approved source that is not current with its approved definition, whatever the cause
    When the process maintaining the approved source runs
    Then the role the agent runtime instantiates is current with its approved definition

  @bounded-context:shopsystem-product @feature:feat-roles-availability @hash:219547cc8cb5
  Scenario: the check passes clean when every approved role is available
    Given every approved role definition with a role available to the agent runtime, current with it, and no other role available to the agent runtime
    When the maintaining process's check runs
    Then the check reports no divergence, no missing role, and no role without an approved definition
```

## Edges

| Case | Who named it | Covered by |
|---|---|---|
| An approved role definition the agent runtime cannot instantiate | the framing ("the shop's approved role definitions cannot be instantiated by the agent runtime") | Scenario: an approved role definition with no available role is reported; Scenario: an approved role definition is available at the point of work — the framed remedy |
| A role the runtime instantiates that comes from the frozen corpus, unapproved on this branch | the framing ("what it instantiates instead comes from the frozen corpus"); the For whom section ("the two roles the runtime does instantiate come from the frozen corpus, unapproved on this branch") | Scenario: an agent fills a role from the approved source at the point of work — the framed remedy: the runtime loads the role from the approved source, so the corpus is not what it instantiates from; and Scenario: a role available to the agent runtime that traces to no approved definition is reported — for a stray role standing at this branch's load point; the corpus's own load, outside this branch, is out of reach by the Appetite's third no-go |
| Making a role available belongs to no process | the framing ("making a role available belongs to no process") | Scenario: an approved role definition is available at the point of work — the process maintaining the approved source is the actor that makes it available |
| A role in the approved source not current with its approved definition | the For whom section's measure ("an approved source that is current with the definition") | Scenario: a role in the approved source not current with its approved definition is detected |
| A role in the approved source no longer current with its definition, whatever the cause | the For whom section's measure ("current with the definition") | Scenario: a role not current with its approved definition is reconciled |
| A role definition that does not stand approved | the framing's outcome ("the approved definition of that role", "an approved source") | Scenario: a role definition that does not stand approved yields no available role |
| An agent fills a role at its point of work | the framing's outcome ("operates from the approved definition of that role, loaded at its point of work") | Scenario: an agent fills a role from the approved source at the point of work (lead-po as the exemplar role: the maker role whose output this shop checks most often, one of the 6) |
| Every approved role available — the target 6 of 6 | the For whom section ("Target: 6 of 6") | Scenario: the check passes clean when every approved role is available |
| Deepening the role definitions (brief-030 ask 1) | the initiative's Appetite | Out of scope: availability does not depend on depth; the roles stand approved as they are |
| Using the frozen corpus's role material as source | the initiative's Appetite | Out of scope: the approved definitions are the only source; the authority ruled the corpus import out on 2026-09-02 |
| Touching what the frozen corpus loads before cut-over | the initiative's Appetite | Out of scope: the corpus is frozen; this branch never publishes to it — a role from it is reported, never altered |
| Widening beyond roles | the initiative's Appetite | Out of scope: the authority's "more comprehensive work later", filed as a backlog item |

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-03 | update | Authored by the PO role alone in the feature-authoring draft step, from init-roles-availability's Framing and For whom sections; eight scenarios, all owned by the lead shop per the initiative's Decomposition; interaction types none per its For whom; scenario hashes computed as sha256 of the scenario's text (its Scenario line and steps), first twelve hex digits, as in feat-skills-availability. |
| 2 | 2026-09-03 | review | PO output check round 1 (judge: claude-fable-5-1 / screen prompt v6): three wobbly findings, none confident — the corpus-sourced roles' Edges row covered only by the stray-role check, which sweeps this branch's approved source and load point, not the corpus's own load (row re-covered by the consumption scenario, the framed remedy, with the stray-role scenario's reach stated); scenario 2's Then led with "operates from", not the observable (re-led with what the runtime instantiates: loaded from the approved source, current with the definition); scenario 7's Given named hand-editing, a cause the framing does not name, while the framed cause — the definition amended after the render — had no reconcile scenario (Given generalized to any cause, scenario retitled). Two scenarios changed text, so two new hashes. Repaired. |
| 3 | 2026-09-03 | review | PO output check round 2 (judge: claude-fable-5-1 / screen prompt v6): findings — scenario 8's Given did not set up its Then's third clause (confident; Given extended with "and no other role available to the agent runtime", new hash); Edges row 5 still enumerated causes while scenario 7's Given says "whatever the cause" (wobbly; row reworded to the scenario's words); the Feature narrative repeated in the Gherkin block (wobbly). Repaired; the narrative duplication ruled typedef-mandated by the PM role. |
| 4 | 2026-09-03 | review | PO output check round 3, the cap (judge: claude-fable-5-1 / screen prompt v6): three wobbly findings, none confident, no uncovered defect — scenario 2's "loaded from the approved source" as provenance rather than observable (held: round 1's deliberate wording, and the second clause is the observable); Edges row 1 naming only the detection scenario (repaired post-cap by the PM role, disclosed: the remedy scenario added, mirroring row 2); lead-po as the untraced exemplar in scenario 2 (repaired post-cap, disclosed: the reason added to Edges row 7; scenario text unchanged, hashes unchanged). |
| 4 | 2026-09-03 | state | `draft` → `checked`: the PM role's pass on the round-3 review — no named criterion missed with confidence in three rounds; the confident finding of round 2 (scenario 8's Given) repaired and not recurring. |
| 5 | 2026-09-03 | state | `checked` → `assigned`: the scenario-assignment record step. One assignment entry — context shopsystem-product (the lead shop), scenarios @hash:ce98da2b6467, @hash:cb8d69b7d24e, @hash:c69e5a0eef5d, @hash:1df06aa89e36, @hash:e0d4e526c948, @hash:9d04a8d0a3b9, @hash:d707d4311bdf, @hash:219547cc8cb5. Pre-state read: the initiative's Decomposition ruling — no Bounded Context touched; the source definitions, the render, and the load point all in the lead shop's tree, the load point `.claude/agents/` absent on this branch; the owning shop matches the Contributors section for every scenario; the feature repository swept in full — two artifacts, this feature and feat-skills-availability, no conflict: the two features specify checks over different definition kinds (process definitions rendered to `.claude/skills/` by the skill-rendering process; role definitions made available to the agent runtime by the process maintaining their approved source), feat-skills-availability's Edges place role definitions out of its scope, and the stray-role scenario (@hash:9d04a8d0a3b9) and the clean pass's third clause have no counterpart there to contradict — a stricter clean condition for a different kind at a different load point; no BC contract in the pre-state — the decomposition names no context whose contract bears on these behaviors. Sent: none — the owning shop is the lead shop itself; the freeze bars dispatch and no Bounded Context exists to receive; the gap stands as lead-ki66p. |
| 6 | 2026-09-03 | review | Delivery witnessed in the running system (the role-rendering definition's O2 names this record as scenario 2's witness). Before the run, a fresh headless session in this tree listed the agent types `lead-architect` and `lead-po` with the frozen corpus's descriptions and none of the six approved roles. After the role-rendering run (6 of 6 rendered to `.claude/agents/`, check clean round 2), a fresh headless session listed cold-reviewer, lead-pm, lead-po, lead-product-designer, lead-solutions-architect, researcher, and no `lead-architect`; that session instantiated `lead-po` (@hash:cb8d69b7d24e), which quoted its own instructions' opening verbatim: the compiler's header "Generated from `basis/roles/lead-po.md` by `basis/tools/compile_role.py`" followed by "You hold the role that makes the requirements." — the approved definition's text, current with it (the check's `ok lead-po`). Measure: 6 of 6. Scenarios 1, 3–8 are witnessed by the process definition's outcomes and its first run's record. |

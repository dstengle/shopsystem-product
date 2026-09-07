---
type: decision-brief
id: brief-039
status: decided
date: 2026-09-07
reader: product-authority
decisions-requested: 3
annex: annex-039.md
relates-to:
  - initiatives/init-run-efficiency.md
  - initiatives/init-process-runner.md
  - features/feat-process-runner.md
  - decisions/adr-2026-09-07-coordinator-role.md
  - decisions/pdr-2026-09-07-bet-process-runner.md
  - basis/roles/router.md
  - requests/req-2026-09-07-contributors-body.md
version: 3
---

# Brief 039: the router ran; three decisions

You bet this afternoon on a process runner that is a cheap model, not code. It exists and it ran. The runner is a new role, the *router*, on the smallest model tier (the harness's haiku). It moved two real processes step by step: request-intake on the request for the feature typedef's Contributors rule, and the small-change lane that request routes to (the *lane*: define, make, check, verify, no bet). It held at a failed command, held for a missing answer, took a cancel on confirmation, and recorded every branch it took. The end-to-end run stopped inside the lane, for a reason Ask 2 settles: the roles the router launched ran on its cheap tier too, and the lane's make step on that tier rewrote the feature typedef beyond its brief. I reverted that change; nothing else was harmed. Three decisions: confirm the router role and the one prompt change it needed (1), set the tier the launched roles run on (2), keep or raise the router's tier (3).

**What was built.** A *run* is one execution of a process definition; its *anchor* is the work item the run records itself on, so a router started later continues from it. The router reads the definition's rendered skill and the anchor, runs each runtime step as written, launches each agent step with only that step's declared inputs, holds the run at each human step, and decides nothing a step decides. The one change outside the router: every process skill now ends each agent step with a line telling the agent to return its declared outputs by name, so the router branches on values, not prose.

**What the runs showed.** Thirteen of the feature's nineteen scenarios were seen to hold on the two run records; six wait on the re-run. The router's own context per turn ran from 70k to 600k tokens, against about 1M per turn for the lead-pm (my role, agent-assisted) before; the spread comes from the whole process skill loading at every start, which a later sub-initiative on artifact tools addresses. Three times the router broke its own definition, once before hardening and twice on the runs; each is now one line in the definition.

**What gates and what defaults.** Ask 1 confirms rulings in force; on silence they stand. Asks 2 and 3 gate the re-run; on silence each default applies and the re-run starts.

**Ask 1 — confirm the router role and the prompt line.** Both were made under your bet: the role definition and the declared-outputs line on every process skill. The three breaks argue for confirming: each was found by a run, fixed by a line, and the fixed definition is what the re-run tests. Evidence: the role check and the lint pass; the two run records. Recommendation: confirm both. *Default:* stand.

**Ask 2 — which tier do the launched roles run on?** No role definition names a model, so a role runs on whatever launched it. Under the lead-pm that was this session's tier, Fable; under the router it is haiku, and the make step showed what that costs. Options: (a) each role definition names its tier — the lead-pm, lead-po, lead-solutions-architect, lead-product-designer, and cold-reviewer on Fable, the router on haiku; (b) every role on haiku, the definitions tightened by the lane as breaks appear, at unbounded cost; (c) the router names one tier for every role it launches, a role's tier in the wrong definition. Recommendation: (a) — the roles' work was good on Fable, and the saving the bet aimed at is the router's context, not the roles'. *Default:* (a).

**Ask 3 — keep the router on haiku?** The architecture decision record for the router (adr-2026-09-07-coordinator-role) names repeated breaks as the trigger to raise its tier. Two breaks happened on the runs, both now lines in the definition, so the trigger as written has fired. Recommendation: restate the trigger as a break after hardening, keep haiku for the re-run, and raise to the next tier (sonnet) on the first break the re-run shows. *Default:* keep.

## Deferred (notes, not asks)

- Six scenarios wait on the re-run: the unreadable condition, an ask returned by a step, a person's hold, a sub-process returning its result, a human step held, and end to end.
- The measure is the router's context per delivered feature; the per-turn numbers above sum to it only after the end-to-end run, so it is not read yet.
- Run efficiency is a parent initiative with four sub-initiatives you ordered; this is the first. The second, run measurement at session close, opens after this one closes.

## Annex

Optional: [annex-039](annex-039.md) — the artifacts with versions, the two runs step by step, the router's context per segment, the three defects and their lines, and this brief's cold read.

## Document History


| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Composed by the lead-pm's assisting agent from the build report and the anchors; three asks, three deferrals; read against the two guidelines before the cold read: every proper noun glossed at first use, each ask in four parts. |
| 1 | 2026-09-07 | review | Cold read, the one round the definition allows (judge: claude-fable-5-1, cold-reviewer, fresh context): findings — the two processes and the roles' prior tier unnamed; the run's stop explained after the asks; the prompt line's scope unclear; "observed" without a result; "well under" against 600k; twelve terms unglossed; Ask 3's trigger already fired on the brief's own count (cannot-decide); the measure's per-turn numbers presented as suggesting a per-feature result. |
| 2 | 2026-09-07 | update | Revised once on the cold read: the two processes named and the stop explained in the opener; the prompt line inside Ask 1; "seen to hold"; the spread explained and the comparison stated plainly; Fable and haiku named, the roles listed; option (b)'s cost and (c)'s difference stated; "coordinator" replaced by router; the decision record named; Ask 3's trigger confronted and restated; the measure's deferral corrected; the lane, the lead-pm, and the sub-initiative structure glossed. Self-read after the revise: every proper noun glossed at first use, each ask in four parts, the decision layer within the cap's variance. |
| 2 | 2026-09-07 | state | draft → delivered after the one revise the definition allows; no finding left open. |
| 3 | 2026-09-07 | state | delivered → decided: the authority's ruling ("keep defaults on rulings, fix the role to model mappings") — Ask 1 confirmed (the router role and the declared-outputs line); Ask 2 option (a), each role definition names its tier, to be made now; Ask 3 keep haiku, the trigger restated. |

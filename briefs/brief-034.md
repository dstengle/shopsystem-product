---
type: decision-brief
id: brief-034
status: delivered
date: 2026-09-03
reader: product-authority
decisions-requested: 4
annex: annex-034.md
relates-to:
  - initiatives/init-roles-availability.md
  - features/feat-roles-availability.md
  - decisions/adr-2026-09-03-role-rendering.md
  - decisions/pdr-2026-09-03-bet-roles-availability.md
version: 6
---

# Brief 034: roles availability delivered, for your ratification

**Open findings at the round cap (four cold reads), with the answers
here.** Ask 1 ratifies this bet only — its appetite was one working
session of the lead shop — and carries no standing ruling: the
outcome clause's disposition below is the lead-pm's reading of one
finding, noted, not a precedent you set by silence. Ask 2's four
post-cap repairs are listed one by one in the annex; the risk if the
two behavior changes are wrong is a finding routed to the wrong exit
for one run, which the next run's check catches; the six renders
themselves are proven by the fresh-session demonstration. That
Asks 1 and 2 default to "stands" on silence is an accepted tradeoff:
it is how the flow treats decisions already recorded on your
direction, and either can be reversed by a cancellation. Terms the
reader stumbled on: the measure is "approved roles the agent runtime
instantiates from an approved source current with its definition,
target 6 of 6"; cut-over is the migration's promotion of this branch
to `main`; the check is the role-rendering process's step that diffs
each rendered role against a fresh render; "solution words" are the
technology and structure names the screen's scenario 4 forbids in
the framing; `lead-…` ids name items in the shop's work register.

You directed one session to make the approved role definitions
available to agents, as the skills were, and, judging the work
low-risk, said to run the product flow through to the end. It ran
through: the six approved
roles — lead-pm, lead-po, lead-solutions-architect,
lead-product-designer, cold-reviewer, researcher — are now rendered
into `.claude/agents/`, the directory the agent runtime instantiates
roles from, on this branch. You were absent at the two decisions the
flow reserves for you, the bet and the process approval (Asks 1 and
2); the lead-pm took them on your direction and recorded them so. Do
they stand, and how should two gaps the run exposed be ruled?

**The answer.** The measure is met in the running system: 6 of 6
approved roles instantiated from the rendered copies, each byte-equal
to a fresh render of its definition. Before, 0 of 6: four of the six
did not exist for the runtime at all, and the two it did offer,
`lead-po` and `lead-architect` (the pre-migration name of the
architect role), it read from the frozen corpus's `main` checkout
even in a session opened on this branch — old prompts, unapproved
here, which the initiative excludes touching until cut-over. Proof
independent of the check, for one role: a fresh session on this
branch lists the six roles and no `lead-architect`; its `lead-po`,
asked to quote the opening of its own instructions, returns the
header the role compiler (`compile_role.py`, the tool that renders a
definition into an agent file) stamps on every render — text that
exists only in a rendered copy. The other five rest on the check's
byte-equality. Recommendation: ratify the two decisions taken for
you (Asks 1, 2), amend the initiative screen (Ask 3), and authorize
the fix for a gap in both rendering processes (Ask 4).

**Ask 1 — ratify the bet on `init-roles-availability`.** The cold
screen (a fresh-context judge scoring the initiative against its
fitness scenarios) reached its three-round cap with two findings the
judge could not decide. First, the word "claude" in your quoted
framing sentence — a technology name where the scenario forbids
solution words; Ask 3 disposes of it. Second, the outcome clause
"maintained by a defined process with its own check", which a judge
may read as prescribing a mechanism. The lead-pm's disposition, for
your ratification here: the clause names a property the source must
have — kept current, and checked — not the mechanism that gives it,
so it is an outcome; Ask 3 does not reach it, and it will draw the
same undecidable finding wherever that outcome is reused, which you
ratify past by ratifying this. Recommendation: ratify. *Default on
silence:* stands.

**Ask 2 — ratify the approval of the `role-rendering` process
definition.** Screened three rounds; every defect the judge could
decide was repaired. At the cap, four repairs were made after it and
disclosed in the definition's Document History, not re-screened, as
the skill-rendering approval allowed last time. Two change behavior:
a quoting fix in the step that separates findings already filed to
you from open ones, so multi-word rows are read whole; and a stated
rule that a definition the compiler refuses yields one finding, not
two. Two are wording: one sentence aligned with the format of the
finding rows the check emits, and one clause. Its first run found
six roles missing, rendered them, and the re-check found nothing —
a clean exit confirmed by the fresh-session proof above, which Ask 4
explains is needed. Recommendation: ratify. *Default:* stands.

**Ask 3 — exempt the originator's quoted words in the initiative
screen.** Scenario 4 of the initiative fitness set forbids solution
words in the framing and exempts nothing quoted, so your own words
naming a tool have drawn the same undecidable finding on both
initiatives so far. Proposed wording, added to the scenario's Then:
"words inside the originator's quotation are exempt". The originator
is whoever expressed the intent — any framer, not only you — and the
initiative's Framing section attributes the quotation by role and
date, which is how the screen tells. The residual risk, a solution
smuggled in by quotation, is bounded because the screen still reads
every unquoted sentence, and the quotation is evidence of intent,
not a requirement. Recommendation: amend. *Default:* unchanged; the
finding recurs.

**Ask 4 — close the false-clean gap, filed as lead-xmuft.** In both
rendering processes, `skill-rendering` and `role-rendering`, a check
step that crashes yields no rows, and no rows route to the clean
exit. The architect met it once in this session, on a first attempt
of the role-rendering run under a different shell that handed the
compiler one malformed path; the compiler crashed on it and emitted
nothing. The run that counts was re-done and its clean result is
confirmed by the fresh-session proof above, not by the check alone.
Recommendation: authorize the architect to amend both compilers
(one per kind: skills, roles) to emit a finding row for any path they
cannot read instead of crashing, and both definitions to treat a
nonzero step exit as failure; you approve the amended definitions
when they come back. *Default:* filed only.

## Deferred (notes, not asks)

- Merging the two rendering processes into one: your "more
  comprehensive work later", filed as lead-sx9xj. The same item
  carries a disclosure: the principles page compiled into every
  session is a rendering with no process behind it yet.
- Recording a run in its process definition's Document History
  changes the definition, so its rendered skill diverges until the
  next skill-rendering run — caught and re-rendered this session.
  Filed as lead-ghaiq, feeding lead-sx9xj.

## Annex

Optional: [annex-034](annex-034.md) — artifacts, screen rounds, run
outputs, the demonstration transcript, and every ruling the lead-pm
made in your absence.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-03 | update | Composed by the lead-pm from the session's records for the authority's ratification. |
| 2 | 2026-09-03 | update | Revised on cold read round 1: terms glossed at first use, the running-system proof explained, Ask 1 split into the two decisions it bundled (four asks), Ask 4 tied to the proof so the clean result is not the false-clean it describes. |
| 3 | 2026-09-03 | update | Revised on cold read round 2: the six roles named and the baseline accounted for all six; the second open finding of Ask 1 explained and dispositioned; Ask 2's four post-cap repairs named and the false-clean caveat placed there; Ask 3 carries the proposed wording and how the screen tells a quote is yours; "owner" replaced with you; the stale-carrier dynamic filed (lead-ghaiq). |
| 4 | 2026-09-03 | update | Revised on cold read round 3: the baseline sentence rewritten (the four absent roles, `lead-architect` as the old name, the `main` checkout read even on this branch, the proof scoped to one role); Ask 1's second finding given a disposition for ratification; Ask 2's repairs marked behavior or wording and not re-screened; Ask 3's originator scoped to any framer with the risk argument matched; Ask 4's cause and two compilers stated; the cut-over bullet folded into the baseline. |
| 5 | 2026-09-03 | review | Cold read round 1 (judge: claude-fable-5-1, general-purpose fill): findings — thirty unglossed terms, Ask 1 resting on trust, the running-system proof unexplained. |
| 5 | 2026-09-03 | review | Cold read round 2 (judge: claude-fable-5-1, the rendered cold-reviewer role): findings — the six roles unnamed, the baseline half-accounted, Ask 1's second finding undispositioned, Ask 3 without wording. |
| 5 | 2026-09-03 | review | Cold read round 3 (judge: claude-fable-5-1, cold-reviewer): findings — the baseline sentence, Ask 1's disposition by authorship, Ask 3's originator scope, Ask 4's cause. |
| 5 | 2026-09-03 | review | Cold read round 4 (judge: claude-fable-5-1, cold-reviewer): findings — Ask 1's hidden precedent, Ask 2 not decidable from the repair inventory, defaults on silence unmarked, five load-bearing terms unglossed. Failsafe exit. |
| 5 | 2026-09-03 | state | draft → delivered at the round cap; the open findings stated and answered at the top of the brief. |
| 6 | 2026-09-04 | update | `relates-to` added under req-2026-09-04-brief-relates-to at the small-change process's make step, naming the initiative, feature, and two decision records the brief is about; the brief is delivered and its content is unchanged. Made by the lead-solutions-architect role. |

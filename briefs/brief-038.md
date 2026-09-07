---
type: decision-brief
id: brief-038
status: delivered
date: 2026-09-07
reader: product-authority
decisions-requested: 2
annex: annex-038.md
relates-to:
  - initiatives/init-tool-skills.md
  - features/feat-tool-skills.md
  - features/feat-tool-skills-rest.md
  - decisions/adr-2026-09-07-tool-answer.md
  - decisions/pdr-2026-09-07-bet-tool-skills.md
  - basis/types/tool-description.md
  - basis/processes/skill-rendering.md
  - requests/req-2026-09-06-tool-skills.md
  - requests/req-2026-09-06-migration-review.md
  - requests/req-2026-09-07-contributors-body.md
  - requests/req-2026-09-07-messaging-invocations.md
version: 2
---

# Brief 038: every tool has a skill; two decisions

You said "make the tool skills or we won't be able to operate", then
"prove it on the lint first" and "if it passes then proceed to the
rest without asking me". It passed, and the rest is done. Every tool
the shop runs — twelve — now has a skill in the directory the harness
loads skills from (the *load point*), and an agent in a fresh context
used ten of the twelve through the skill alone on the first try; the
two it could not use are barred by the freeze (the messaging command
`shop-msg` and the closing command `bc-emit`, neither owned by this
shop). Two decisions: confirm the three definitions this work changed
on your direction (1), and set the order of the next work (2).

**What was built.** A *framework tool* is a program the shop's
definitions name. Each tool now answers one flag, `--describe`, by
printing its uses as data — for each use what it does, what it takes,
what it returns, how it fails — and then exiting without doing
anything else. A new compiler, the *producer*, turns that answer and
nothing else into the tool's skill. Six tools the shop owns answer:
the lint and the five compilers, the producer included. Six tools it
runs but does not own cannot answer, so a *description* in the same
shape stands beside each, written from the tool's own help and
observed behaviour, and one request record per tool — the *gap
record* — is held for the tool's owner until it answers. The check
that keeps the load point current asks every tool each run and
reports any skill not current with what its tool says. The
initiative's measure — tools usable through a skill produced from
the tool's own answer — reads 6 of 12; the described six are usable
now and are counted when their owners answer.

**What gates and what defaults.** Ask 1 confirms rulings in force; on
silence they stand. Ask 2 gates the next session's first action; on
silence the migration review opens first.

**Ask 1 — confirm the three definitions changed on your direction.**
Your bet of 2026-09-07 and the direction quoted above were the
authority for three changes to definitions you own, each in force
now and pending your approval — a no reverses it. (a) A new data
type, tool-description: the shape every answer and description must
parse against; the designer screened its field names against the
vocabulary, as the decision record requires. (b) The skill-rendering
process, amended to check the twelve tool skills beside the 22
process skills it already checked. (c) The six answering tools now
reject any argument they do not know and exit with a coded failure,
where before some printed help, some ran anyway; the change makes
every failure the tool gives one its skill names, so an agent can read
any failure from the skill. Evidence: the lint passes; the check runs
clean over all 34 skills; every one of the twelve is byte-equal to a
fresh production; ten fresh-context agents met eleven failures and
read each from the skill. Recommendation: confirm. *Default:* stands.

**Ask 2 — what opens next?** Two pieces of work are accepted and
waiting. The migration review: a discovery from evidence on how the
migration is being done, your direction of 2026-09-06. And one small
change to the feature typedef: both features' screens found the
contributors' section overloaded with reasoning that belongs in the
document history; the typedef does not say so; the change is one rule
in one section, and it also removes the one instruction the lead-pm
gave by hand today. Recommendation: the migration review first, then
the typedef rule. *Default:* that order.

## Deferred (notes, not asks)

- Whether a tool's `--help` should also print its answer in prose:
  today help prints one usage line and exits with a failure code, and
  the skill is the help. Ruled no by the lead-pm — one source, one
  rendering; say so if you want it otherwise.
- Two process steps invoke the messaging command in a form the tool
  rejects (assignment's dispatch, closing's consume). Recorded for the
  lane — the small-change path: defined, made, checked, verified, no
  bet — and held until the freeze lifts, since neither step runs
  while frozen.
- Two of the six gap records name no owner: the work register `bd`
  and the credential proxy `agent-vault` show none in their version
  and help output. The lead shop holds those gaps as its own until an
  owner is found; nothing happens to them until one is.
- The gap record has no addressee field; the owning shop is named in
  its body. A lane change if wanted.
- Two requests from brief-037 still await your answer on their
  defaults, nothing acted on: one rule in the writing style that the
  lead-pm say plainly what work waits on (lane); one discovery on how
  steps and agents should communicate (discovery).
- init-tool-skills stands `active` with both features delivered; the
  `completed` state is still a pending amendment.

## Annex

Optional: [annex-038](annex-038.md) — the artifacts with versions,
the twelve tools and their sources, the proof runs, the screens with
their counts, the timeline (2 h 7 min by commit times for both
features), the rulings taken by default, and this brief's cold read.

## Document History


| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-07 | update | Composed by the lead-pm role's assisting agent from the session's records at the stakeholder-presentation frame and compose steps: reader the product authority; three asks kept (the definitions confirmed, the help question, the order of next work), four deferrals; the agent's own read against the stakeholder-communication and base writing style guidelines before the cold read. |
| 1 | 2026-09-07 | review | Cold read, the one round the definition allows (judge: claude-fable-5-1, cold-reviewer, fresh context): findings — the opener's "used each" against the two tools the freeze bars; Ask 1's third change ambiguous in direction and without its own evidence (wobbly); Ask 3's typedef item not parseable as work and its held item unorderable (wobbly); Ask 2 decidable but gating nothing; thirteen terms arriving before their introduction (load point, the run, gap record, the measure, the freeze, the bet, standing direction, the lane, scope call, screens, provenance, request typedef, the two commands); the built paragraph dense; the cost paragraph deciding nothing; the maker's self-read asserted without its result. |
| 2 | 2026-09-07 | update | Revised once on the cold read: the opener says ten of twelve, names the two barred tools and that neither is owned here; load point, producer, description, gap record, and the measure introduced where first used; "the run" and "standing direction" replaced by the bet's date and the quoted direction; Ask 1's three changes lettered, (c) restated from the tool user's side with its own evidence (eleven failures read from the skill); the help question moved to Deferred with the lead-pm's ruling and Ask 3 renumbered 2, decisions-requested 2; the typedef item stated as work (what was found, what the rule does); the messaging item moved to Deferred with the lane glossed; the cost paragraph moved to the annex pointer; the brief-037 requests described in words; the maker's self-read recorded here: read against the two guidelines after the revise — every proper noun glossed at first use, each ask in four parts, the decision layer 439 words — over the 400 soft cap and within its 20 percent variance, the two asks kept whole — the consistency sweep run (counts 12, 6, 6, 22, 34, and ten agents match the annex). |
| 2 | 2026-09-07 | state | draft → delivered after the one revise the definition allows; no finding left open. |

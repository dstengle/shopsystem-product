---
type: artifact-typedef
id: initiative-typedef
defines: initiative
owner: product-authority
status: approved
approved: 2026-08-31
version: 6
created: 2026-08-28
updated: 2026-08-31
ancestry: [initiative]
---

# Artifact type: initiative

## Identity and ancestry

- **Type:** `initiative` — the product-level problem artifact: one
  problem worth solving, stated for the product, not for any Bounded
  Context. It carries the outcome the problem serves and how that
  outcome is measured, the appetite the product will spend, what it
  will not do, and — once attached — the feasibility verdict and the
  decomposition. It is the home of the framing: the PM role's recorded
  statement of what a request is about is its first section and lives
  nowhere else. Features are made from it and link it. It is bounded
  to 500 words by rule, so its check reads the whole of it and there
  is no second document to keep in step. `ancestry` names no generic root: an initiative is
  neither a request nor a definition, as the feature typedef also
  states.
- **Produced by:** the [PM role](../roles/lead-pm.md), in the
  [discovery conversation](../processes/discovery-conversation.md) —
  the role's assisting agent drafts, the PM decides its content.
- **Attached and screened in** the
  [initiative-check](../processes/initiative-check.md) process: it
  mirrors the PO output check with maker
  `lead-pm`; before the screen, two attach steps: the solutions
  architect role attaches the decomposition and its feasibility verdict,
  then the product designer role attaches its usability evidence or
  hypothesis; then the cold reviewer's screen against the
  [initiative fitness set](../fitness/initiative.fitness.md); then the
  authority's decision. That screen is the *check of record*:
  the check whose verdict the definitions rely on, since the authority
  holds the PM role in person and no other role checks the PM's
  framing. What it checks is completeness and form — originator
  quoted, one measure, a bound, no solution, attachments present. It
  does not check whether the problem is worth solving; that value
  judgment stands unchecked by design and rests on the recorded
  originator's words and the measure. The authority *bets* on a
  screened initiative — decides to spend the appetite — in that
  process's own decide step, a human step.
- **Consumed by:** the PO role, which makes features from it; the
  solutions architect role; the PO output check, where a feature's
  `framing` input names this document's first section.

## Required frontmatter

`type: initiative`, `id`, `status`, `version`, `name`, `owner`
(`lead-pm`), `created`, `updated`. `approved` does not apply; the
lifecycle stands in. Status values and their writers:
- `proposed` — the PM role, when the discovery conversation's `frame`
  step records it: the framed-but-unbet state.
- `planned` — the authority's bet, taken and recorded in the
  [initiative-check](../processes/initiative-check.md) process's
  decide and record steps, replacing `proposed`.
- `active` — the PO output check's record step, when the first feature
  made from it passes (amendment pending: the step reads the feature's
  `initiative` link).
- `completed` — the [reconcile-and-close](../processes/reconcile-and-close.md)
  process, when the last delivery under it is reconciled — read from
  §6 and each feature's state — and the measure is recorded against
  its target (amendment pending).
- `cancelled` — with the reason recorded, from `proposed`, `planned`,
  or `active`: a request declined at discovery is recorded `proposed`
  and cancelled in the same discovery conversation (its `frame` step),
  so the record of what was declined survives; a cancellation at the
  bet is taken in the initiative-check decide step and written by its
  record step; a later cancellation is
  the PM role's decision recorded as an outcome of the
  [review conversation](../processes/review-conversation.md)
  (amendment pending).

## Required sections

1. **Framing** — the originator (who expressed the intent, quoted in
   their own words), the problem taken to be worth solving, the outcome
   it serves, and the contract — product or operational — it entered
   through. The PM role's exclusive decision.
2. **For whom** — who has the problem; one measure with its current
   condition, quantified, and its target; and the interaction types the
   outcome must hold on, from the
   [core-task list](../experience/core-tasks.md), or "none" with the
   reason.
3. **Appetite** — the bound the product will spend — time or capacity
   — that the features stay within; and the no-gos: what this
   initiative will not do, each with its reason.
4. **Feasibility and usability** — the solutions architect role's
   feasibility verdict with its reasons, present; and, where §2 names
   an interaction type, the product designer role's usability evidence
   or the hypothesis it stands on, or "not yet" with the text of the
   ask that requests it.
5. **Decomposition** — attached by the solutions architect role: the
   Bounded Contexts the initiative touches, the relationship kind of
   each contract between them it relies on, and the cross-context flow
   in one place — the saga or process manager (the one component that
   routes the flow between contexts) that will carry it, or "none" when
   the contexts need no flow between them. "Not yet" until attached.
6. **Features** — the features made from it, by id, as they are made;
   empty until the first.

## Rules

- The framing is written here and nowhere else; a check that names the
  framing as a criterion reads §1.
- Sections 1–3 name no technology, structure, or interface form; an
  interaction type named in §2 is a what.
- At most 500 words outside the Document History; the bet — what is
  spent on what, for which outcome — must be statable from §1–3 alone.
- The go/no-go and a cancellation are each carried by a
  [product decision record](product-decision-record.md) the PO role
  makes for the decision and the PO output check screens, linked from
  the Document History state entry; for the go/no-go, `decided-by` is
  `product-authority` and `right` is `bet`, values the decision-record
  typedef admits.
- The count of initiatives whose §5 names more than one Bounded
  Context, per quarter, is a report the solutions architect role
  reads through its interface with the PO role; a rising count is its
  signal to review the decomposition, recorded as an architecture
  decision record.

## Commitment (Definition of Done)

An initiative is done — able to be bet on — when it has passed the
cold reviewer's screen against its fitness set, which requires the
feasibility verdict present and the measure with a current condition
and a target. **Consequence on failure:** it stays `proposed` with the
criterion named; no feature is made from it.

## Sources

Cagan's product opportunity assessment (the problem, for whom, how
big); Torres's opportunity as distinct from any solution; Perri's
target condition with a measured current condition; Basecamp's pitch
(appetite, no-gos); Linear's initiative statuses; the CQRS Journey's
process manager and saga for the cross-context flow; all as the
research report `product-process-2026-08` on the `research` branch
carries them; the shop's `define-good-up-front` principle for the check
of record.

## Derived review checklist

- Framing carries originator quoted, problem, outcome, contract. *(§Required sections 1; fitness 1)*
- Who; one measure with current condition and target; interaction types or "none". *(§Required sections 2; fitness 2)*
- Appetite bounded; every no-go reasoned. *(§Required sections 3; fitness 3)*
- Sections 1–3 name no solution or interface form. *(§Rules; fitness 4)*
- Feasibility present; usability present or asked where §2 names a type. *(§Required sections 4; fitness 5)*
- Decomposition attached or "not yet"; flow named or "none". *(§Required sections 5; fitness 6)*
- At most 500 words; the bet statable from §1–3. *(§Rules; fitness 7)*

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-28 | update | Authored by owner direction as the product-level artifact the brief's retirement left missing — the system-read report's 13(a): the framing absorbed as its first section, made by the PM role, screened by the cold reviewer as the check of record, bet by the authority; lifecycle from Linear, appetite and no-gos from Shape Up, the measured condition from Perri, the decomposition from the product-process report. |
| 1 | 2026-08-28 | review | Screened with the chain: findings — the screen's carrying process unnamed; three status transitions with no carrying process and one misattributed; feasibility "not yet" admitted against the commitment; the no-solution rule unscoped; the one-page bound with no authoritative home; the boundary signal without consumer or action; product decision record's writer in conflict; insider references and undefined terms. |
| 2 | 2026-08-28 | update | Repairs: `initiative-check` named as pending; every transition's writer named, existing or pending amendment; feasibility mandatory, usability may be asked; no-solution scoped to §1–3; the 500-word rule; the signal's consumer and action named; the decision record's maker and check stated; check of record and bet defined in place; the research consumer cut. |
| 2 | 2026-08-28 | review | Re-screened: findings — the bet not statable from §1–2 when it spends §3; the decision record could not carry the authority as decider; `cancelled` with two writers and no process; the attachments in no process. |
| 3 | 2026-08-28 | update | Repairs: statable from §1–3; `decided-by: product-authority`, `right: bet` admitted by the decision-record typedef; both cancellation paths named with their pending amendments; the attachment step placed in `initiative-check`; Produced-by split; a count is a report, not a rendering. |
| 3 | 2026-08-28 | review | Final screen (round 3): clean — the bet statable from §1–3; the decision record carries the authority's bet; both cancellation paths and the attachment step named; consistent with lead-pm, feature, and the decision-record typedef. |
| 4 | 2026-08-31 | update | Batch A of brief-032's plan: the pending process names resolved — initiative-check authored (the bet taken inside its decide step, removing the review-conversation amendment for the bet), the discovery frame step recording proposed and the decline path; active and completed writers stay pending on batches D and the reconcile side. |
| 5 | 2026-08-31 | review | Batch screen round 2: the check's two attach steps described as two. |
| 6 | 2026-08-31 | review | Round-3 screen (final): the at-bet cancellation's writer named (the record step writes what decide takes). |
| 6 | 2026-08-31 | state | draft → approved with batch A+B as one block (brief-032 ask 2, default accepted). |

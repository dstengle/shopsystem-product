---
type: initiative
id: init-typedef-rendering
name: Typedef rendering
status: active
version: 10
owner: lead-pm
created: 2026-09-05
updated: 2026-09-05
request: ../requests/req-2026-09-05-typedef-rendering.md
---

# Initiative: Typedef rendering

## Framing

Originator (product authority, 2026-09-05, through the lead shop's
operational contract, which has no artifact yet (lead-4kymc); the
request req-2026-09-05-typedef-rendering; the authority's accepted
restatement of its section 1, on the framer's-wording ruling): "Whoever makes an artifact
and whoever checks it should work from the same standard, and when the
standard changes it should reach both."

Problem: whoever makes an artifact and whoever checks it work from
different words, because the standard for an artifact type is written
in several places by hand, and a change to it does not reliably reach
both. Outcome: the
maker and the checker of an artifact work from the same standard, a
change to the standard reaches both, and the checker's tests, the fitness
set's scenarios, can be run by the author first.

## For whom

The makers and checkers of every artifact type, and the authority when
the standard changes. Measure: artifact types whose maker and checker
work from one standard and have each used it once — the maker to make
an artifact of that type, the check to screen it. Now: 0 of 22.
Target: 1, the product decision record. Interaction types: none — the standard is
read inside process steps; no core task carries it.

## Appetite

One working session of the lead shop for the proof on the product
decision record: the PO role makes this initiative's own bet record
— the product decision record its bet requires — from the same
standard, and the check that screens that record screens it from the
same standard; a form-only screen counts as the check's use.
The other 21 types follow as one batch, a second bet sized after the
proof. No-gos, each with its reason:

- Any change to the checking processes themselves — a later request;
  the checks are not what this bet changes.
- Checking that the standards of different types agree with each
  other — struck by the authority as not needed here.

## Feasibility and usability

Feasible in one session. The three documents — the guideline, the
fitness set, and the typedef's checklist — already match rule for
rule (guideline rule N, fitness scenario N, checklist item N), so
folding them into the typedef is mechanical. The compiler follows
`basis/tools/compile_process.py`: parse the typedef, write two texts,
stamp a `source-digest`. The artifact-typedef typedef already names
such texts renderings. Rendered at the paths the checks read, the
checks stay unchanged. Risk: the bet's record is checked for form
only, a light first run for the checker's text. No contract exists;
no feature touches typedefs. (architect, 2026-09-05)

No usability attachment is due: the For whom section names no
interaction type — the renderings are read inside process steps, and
no core task carries them. (designer, 2026-09-05)

## Decomposition

None: no Bounded Context is touched. The typedef, the compiler, and
the renderings sit in the lead shop's tree; no contract exists on this
branch to rely on. Cross-context flow: none.

## Features

[feat-typedef-rendering](../features/feat-typedef-rendering.md) — checked.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-05 | update | Recorded `proposed` by the discovery conversation's frame step, on the authority's convergence — "Converged" (work item lead-kda8l; session sess-2026-09-05-a) — the first initiative made from a request through the hinge (discovery-conversation v11). Positions reached in the interview: the slice is the product decision record ("Okay, use the pdr"); the tests stay as they are, executable by the author and by a check, rendered for prompts; the typedef consistency check struck; the sweep is a batch after proving, not demand-pull. |
| 2 | 2026-09-05 | update | Feasibility and decomposition attached by the architect at the initiative-check's attach step. |
| 3 | 2026-09-05 | update | Usability attachment: none due, by the designer at the attach step. |
| 4 | 2026-09-05 | review | Initiative-check screen round 1 (judge: claude-fable-5-1 / screen prompt v5): five confident findings, all scenario 4 — mechanism and structure words ("renderings", "render from it", "one document per artifact type", the originator's "typdef") in Framing, For whom, and Appetite — plus "the tests" unintroduced; wobbly: the batch unbounded, the compound measure, the form-only check, the artifact-less contract, the word bound. Repaired by the lead-pm in its own sections: the outcome stated as its effect; the measure one per-type property with one target; the batch made a second bet; the form-only run counted in the measure; the tests introduced as the fitness set's scenarios. The originator's quote stands pending the authority's restatement (the framer's wording changes — the 2026-09-04 ruling). |
| 5 | 2026-09-05 | review | Screen round 2 (judge: claude-fable-5-1 / screen prompt v5): three confident — the originator's quote (pending the restatement), the measure naming no run while the Appetite counted one, "the check" and "form only" unintroduced — and three wobbly ("derive from" as structure, the first no-go's reason naming the mechanism, the word bound). Repaired by the lead-pm: the measure now counts a type whose maker and checker work from one standard and have each used it once; the Appetite names the product decision record's own check, the PO output check, and drops "form only"; "work from" for "derive from"; the no-go's reason reworded. |
| 6 | 2026-09-05 | update | The design decision this initiative rests on, named by the architect at the attach step, recorded before the bet: [adr-2026-09-05-typedef-rendering](../decisions/adr-2026-09-05-typedef-rendering.md) (checked, v4; three screen rounds; the maker's own check against the fitness set run before round 1; the cap with six wording findings repaired past it and disclosed). |
| 7 | 2026-09-05 | update | Framing quote restated on the framer's-wording ruling: the lead-pm proposed the restatement and the authority accepted it — "Go with your version". The original words of 2026-09-05, moved here from §Framing and standing verbatim on the request's section 1: "My impression was that the typdef included everything including guidelines and fitness checks and those were just renderings. We need to get that in place (if not already) since it will be easier to evaluate everything for consistency for an artifact." |
| 8 | 2026-09-05 | review | Screen round 3, the cap (judge: claude-fable-5-1 / screen prompt v5): one confident — "the three documents" unglossed in the architect's paragraph — and five wobbly: form-only against the measure; whose words the restatement is; "the one standard" and the named check; the no-go naming the checking processes (the owner's open gap); "the fitness set's scenarios" as a structure word. Post-cap repairs, disclosed and not re-screened: the three documents named; the Framing attributes the restatement; "the same standard"; the named check replaced by "the check that screens that record" and the form-only run stated to count. Held for the authority at the bet: the no-go naming what it excludes (the fitness-set gap filed 2026-09-04) and "the fitness set's scenarios" as the gloss a prior round asked for. |
| 9 | 2026-09-05 | state | `proposed` → `planned`: the authority's bet — "Bet" — taken in the initiative-check decide step with the two held findings before it; the lead-pm recording it. The product decision record for the go is the PO role's to make and the PO output check screens it; by the Appetite, that record is the proof itself — made and screened from the one standard once the typedef rendering exists — so it is made after the build and linked here then. |
| 10 | 2026-09-05 | state | `planned` → `active`: feat-typedef-rendering's pass through the PO output check (round 3, the cap; the PM role's pass with post-cap repairs disclosed; seven scenarios, the two batch cases moved to the second bet's feature) — written by that check's record step through its declared framing input. |

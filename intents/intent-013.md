---
type: intent-record
id: intent-013
title: Re-found trust in the typed-artifact system by a phased freeze→shrink→enforce→standard arc, with content-quality doctrine captured iteratively from Phase 0
status: recorded
created: 2026-08-04
updated: 2026-08-04
authors: [dstengle, "Claude (lead-pm)"]
description: "Records the product authority's direction after the 2026-08-03 trust break and the full-system assessment that grounded it: re-found the typed-artifact system in four phases — a scoped freeze with triage, a shrink of the governed core, enforcement that makes green meaningful, then automated carriers and corpus repair — under two amendments the authority set: the quality bar is defined at Phase 0 and applied manually to everything authored during re-founding, and doctrine is captured through an iterative review loop rather than authored one-shot. Automation of quality transfers enforcement off the authority only after the machinery has earned it."
---

## Verbatim anchors

- "I am getting increasingly frustrated with the way the system is
  functioning… I keep finding things that were either implemented incorrectly
  or incompletely."
- "The skills for writing artifacts are far too simplistic and produce very
  poorly thought out things like ADRs."
- "The most recent example of ADR-072 and the edits necessary… make me
  question the quality of all of the decisions."
- "I still believe that solidifying the quality of the artifacts and the
  ability to navigate them is paramount to getting the system back on track."
- "There is a serious need to improve the quality across the system and it
  needs to start with artifacts written to a high standard."
- On the phased proposal: "I'm not sure if the focus is on metadata quality or
  artifact quality overall." — answered by decomposing quality into content /
  legibility / structural-trust and amending the sequence so content quality
  starts at Phase 0.
- "For Phase 0, if we are able to focus on content quality, I'd like an
  iterative process to review and steadily capture doctrine."

## The goal behind the ask

The product authority stops being the system's safety net. Today every check
can be green while decisions are unrealized, unratified, or unreadable — the
2026-08-03 assessment (sess-2026-08-03-b) verified five ranked root causes:
verification aimed at proxies, acceptance decoupled from ratification and
realization, truth duplicated across the BC boundary, decision units oversized
past solo review bandwidth, and a quality standard with no carrier. The goal is
a corpus the authority can trust to read, review, and implement from — with
quality enforced first by the authority over a deliberately small flow, and
then progressively transferred onto machinery only as that machinery is proven
(demonstrated red before its green is believed).

## Who it serves

- The product authority — a solo reviewer whose bandwidth is the system's
  binding constraint and whose trust is the thing being re-founded.
- The agents operating the shop, whose grounding, dispatch premises, and
  authored artifacts are only as good as the corpus they read.
- Downstream BC work, which inherits its quality ceiling from the decisions
  and scenarios the lead ships.

## Constraints

- A scoped freeze holds during re-founding: no new product-direction decisions
  or capability bets; re-founding work is exempt but held to the new bar.
- A standing per-session cap on authored-artifact volume at what the authority
  can genuinely review the same day; the 17-artifact batch of 2026-07-25 is
  the named banned pattern.
- The quality bar is defined at Phase 0 and applied manually to every artifact
  authored during the arc; automation of the bar (skills as carriers, checks)
  comes only in later phases. Doctrine is captured iteratively — review real
  artifacts, distill the authority's verdicts into rules, ratify next
  iteration — never authored one-shot.
- Every phase ends in exactly one small reviewable deliverable; nothing fans
  out until its pilot passes the authority's review.
- No new or changed check is believed until demonstrated failing on a planted
  defect.
- Machines are not asked to check thought quality; it is carried by doctrine
  and enforced at acceptance.

## Non-goals

- Not a rewrite of the shopsystem framework or BC architecture.
- Not corpus-scale repair before checks are meaningful — mass repair
  (summaries, titles, the 45% duplicate-appendix cut) waits for the phase
  whose checks can hold it.
- Not new navigation surfaces: the tag/discovery bet (intent-012 lineage)
  returns later as a re-decision under the new bar, not a resumption.
- Not automated scoring of decision quality.
- Not market-facing product management (out of scope per PDR-033 amendment-c).

## Appetite signal

Phased and deliberately small: Phase 0 in days (freeze declared, triage
dispositions, doctrine loop running), Phase 1 in about a week (one shrink
decision), the whole arc in weeks — with artifact volume capped throughout, so
appetite is bounded by review sittings, not calendar sweep. If capacity forces
a cut, corpus mass-repair scope is cut, never check semantics.

## Failure conditions

- The doctrine loop produces rules nobody applies — the bar becomes one more
  accepted-but-unrealized decision.
- The freeze leaks: normal capability work resumes through the re-founding
  carve-out.
- Batch authoring recurs: any session again produces more artifacts than the
  authority reviews that day.
- A check lands without its red demonstration, or a phase deliverable does not
  itself exemplify the bar.
- After the enforcement phase, the authority is still the first discoverer of
  a realization gap the system's own checks should have caught.

## Open threads

- The authority's numbers: exact freeze scope (what in-flight work continues,
  including intent-012 / cand-010 / brief-025 step 1) and the per-session
  review cap.
- Where doctrine lives: proposed as one governed PDR grown by changelog per
  iteration, accepted when an iteration adds no new rules — to be confirmed in
  the loop's first iteration.
- The Phase-0 triage dispositions themselves: contested adr-072 (lead-ut1e6),
  the 17 unresolved acceptance-review forks in adr-067..071, and the
  proposed-but-load-bearing decision records.
- Sequencing homes for held items: strict frontmatter (lead-j7t0j) lands in
  the enforcement phase; reviewer legibility (lead-nvs7i) is absorbed into the
  doctrine loop; the queued 2026-07-17 framework-self-optimization discovery
  contributes its artifact-quality slice here and otherwise stays queued.
- The full assessment evidence (12-agent sweep, adversarially verified)
  remains in the session transcript; durable homes for its per-plane findings
  are assigned as the phases consume them.

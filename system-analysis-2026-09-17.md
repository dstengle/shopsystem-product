# Where the rebaseline is breaking

## Verdict

Five defects are real, structural, and verifiable in minutes. None of them is verbosity. None of them requires a restart to fix, and a restart would not fix any of them — the pre-rebaseline corpus on `main` carries the same classes with its own occurrence counters ("5th occurrence", "THIRD occurrence", "the autonomy mandate is PROSE the agent may not follow").

The case that the rebaseline is off course is weaker than it looks. Three of its supporting arguments do not survive checking: the delivery-mass argument, the velocity argument, and the verbosity argument. They are the three being used to argue for a second restart.

## The five defects

**1. Nothing in the system reads what the system writes.**
Across all 25 process definitions: 22 `bd create|close|comment` calls, 0 `bd list|show|query`. Across all 9 role definitions: 0 reads. No defined activity ever consumes the defect register. The result: 2–3 of 37 rebaseline defects closed; 206 items inherited from `main` open on 2026-08-21 and all 206 still open. Seven requests sit `routed` and never acted on; `req-2026-09-05-step-communication` is named "awaiting the authority's answer" in 8 consecutive session records. This is not a bottleneck. It is an open loop. The governing principle, `feedback-loops-with-consumers`, is the least-cited in the corpus — 4 mentions in 2 files, against 103 for `define-good-up-front`.

**2. Enforcement was spent on shape. Substance is self-attested.**
`grep -ci 'word' basis/tools/lint_basis.py` → 0. `grep -ci 'hash'` → 0. The lint has no word check, no hash check, no feature-status check, and no check that a link's target is still approved. It prints "vocabulary residue: 19 files" and then exits `PASS: 0 violation(s)`.

The split is clean. Every mechanically enforced constraint holds at 100%: lint PASS whole-tree, `compile_role --check` 9/9, `compile_process --skill` 25/25 identical, `compile_principles` byte-identical to the compiled block. Every judged constraint is breached at 81–100%: 18/18 features over the whole-document word target, 25/25 process definitions, 18/18 decision records. Fitness screens across the four principle sets: 185 `pass` cells, 0 `fail` cells, ever.

`basis/principles.md` — the set compiled into every session — stands `approved` while its own Accepted tradeoffs section says: "The two judged screen rows below claim passes for those principles that the judge could not reproduce. Accepted, and recorded here rather than silently." Three independent cold screens of three different sets failed the same scenario the same way (lead-zddhu, lead-fstd0, lead-u0ow4).

**3. The one always-resident document with no compiler is 17 days stale.**
`.claude/shop/primer.md` was last committed 2026-08-31. It names `initiative-check`, `backlog-ordering` and `po-output-check` as the live product flow. It says deliveries over ~300 words go through `stakeholder-presentation` — "no exceptions". All four carry `status: retired`. It is in this session's own context, verbatim.

Every always-resident document that *has* a compiler verified current when I ran the checks. That is close to a controlled experiment. Around 31 approved documents still cite the retired processes, and the lint passes over all of them, because its link check verifies that a file resolves, not that its target is live.

**4. The system cannot record completion.**
`basis/artifacts/feature.md` states "a feature's terminal state is `assigned`" and defines draft/checked/assigned/returned. Actual: 10 features `assigned`, 8 `delivered` — a value the schema does not define. The lint passes. Initiatives: 13 active, 2 planned, 1 proposed, 0 completed. `completed`'s only writer is `reconcile-and-close`, which the freeze bars from running. A system that cannot mark anything done cannot observe its own throughput. That is why "is this getting better" has no answer inside the corpus.

**5. The implementation principle set says nothing about software.**
Its six principles: built-to-the-scenario, effect-shown, effect-not-mechanism, nothing-lost, knowable-from-the-record, cost-on-the-initiative. All govern scope, evidence, verdicts, regression and accounting. Five of six close on a "The checking role MUST fail…" bullet. Across all of `basis/`: `maintainab` 0 files, `modular` 0, `cohesion` 0, `reliab` 0, `securit` 0, "error handling" 0. The consequence is in the only thing the shop built: 4,461 lines of Python, and `git ls-files | grep -i test` returns nothing.

## What the hypotheses turned out to be

**H1 — verbosity/idea-density. Refuted as stated.** Median sentence length is 10–17 words across definition classes; the style guide itself sits at 9. The process step prompts — the only process text an agent reads — are the *least* dense text measured (22.3 words/unit, 11.8% over 40 words). Verbose definitions are not the channel through which rules reach agents. The real density is created at compilation: 4,053 words of principle carrying 26 obligations become a 537-word session block at one MUST per 21 words, with the rationale stripped by design.

**H2 — `define-good-up-front` was misread. Refuted at its premise.** The seed commit (`git show 52b6e52:basis/principles.md`, day 1) already read "the check MUST sit with a different role holding a different accountability", citing Deming. It was an operating obligation from the first commit. No agent misread it. What was added later (2026-09-05) was the maker-*self*-check — the system moved toward self-check, not toward independent checks. Check steps are also not the process mass: roughly 25 of 207 steps, 14 of 25 processes with no check step at all.

**H3 — the form excludes guidance. Confirmed for implementation, refuted elsewhere.** `basis/architecture-principles.md` carries `knowable-shape`, `contracts-between-contexts` and `local-comprehension` — genuine artifact-shape rules inside the binary-testable form. `basis/experience-principles.md` is artifact-shaped throughout. The form did not make the gap. The gap appeared exactly where the authors were writing about their own activity.

**H4 — constraints waivable by the constrained. Confirmed, with one correction.** "disclosed as not done" in 40 files; 12 amendments in force with the owner's approval "pending"; two role definitions stamped `approved, owner: product-authority` by their own author on 2026-09-17 (lead-mtq44). But this is not evasion. Every waiver is disclosed in the document it weakens, often against the discloser's interest.

**H5 — the authority is the bottleneck. Not established, either way.** Total recorded human wall-clock is 36.6 minutes across 7 cost files covering 32% of sessions, two of them empty. There is no denominator that settles it. 10 of 207 steps are human. 28 of 34 open defects wait on nobody.

**H6 — BCP 14 adopted into judgment documents. Confirmed on count.** In `basis/`: 106 MUST, 21 MUST NOT, 13 MAY, 5 SHOULD — and the 5 SHOULDs are the boilerplate sentence defining the keyword, not uses. The discretion half of the standard is unused. RFC 2119 §6's necessity limit appears nowhere.

## Factor scores

| # | Factor | Panel | After checking | Why the score moved |
|---|---|---|---|---|
| 1 | Delivery vs definition mass | failing | not established | Migration plan puts first product feature in Phase 2; appetites are in working sessions, not days |
| 2 | Artifact-quality coverage | failing | failing (implementation set) | Architecture and experience sets are artifact-shaped; implementation set is not |
| 3 | Enforcement locus | failing | failing | Verified by running the tools |
| 4 | Constraint integrity | failing | failing | Verified; disclosed, not concealed |
| 5 | Outcome feedback loop | failing | failing | 0 reads of the register; 1 measured before/after in the corpus |
| 6 | Form fit | failing | strained | One-form grammar confirmed; two sets escape it in practice |
| 7 | Obligation load | failing | strained | Prose half refuted; the counterfactual was never run |
| 8 | Rejection power | failing | failing | 0 observed rejections citing a principle; fitness *sets* do reject |
| 9 | Check economics | failing | failing | 3 of 3 re-screens disagreed with the author's asserted pass |
| 10 | Flow and constraint | failing | not established | Calendar-day denominators invalid; cost comparison is n=2 with a data artifact |
| 11 | Ceremonial mass | failing | strained | Retirement-without-sweep holds; never-run share is confounded by the freeze |
| 12 | Source fidelity | failing | failing | TOGAF Robust/Stable dropped, Consistent inverted, Spool Test #1 inverted by rule |
| 13 | Decode cost | strained | strained | Glossary healthy (75/82 terms load-bearing); runtime decode cost low, maintainer cost high |

## What the system got right

**The compiler/load-point architecture.** Generate the agent's context from an approved source, stamp it with a digest, check the load point against a fresh render. Four checks passed clean. Every compiled resident document is current; the one uncompiled one is 17 days stale. This is the most reusable thing here.

**The fresh-context cold-reviewer screen.** Different role, fresh context, written criteria. It is the only check with a detection record — 6 defects, including the three that indict the self-screen competing with it.

**Mechanical criteria get executed.** Guidance records are the only artifact class near their word target (median 1.1x against 2.4–4.3x elsewhere). Their fitness scenario says "Count the document's words… State the count and pass/fail". Makers ran `wc -w`. Same authors, same week.

**The small-change lane.** 20 of 41 requests routed there; three changes to verified results in about 14 agent-minutes, against 136 agent-minutes for one full-flow initiative. Same agents, same day.

**`feat-plain-voice` worked, measurably.** Mean feature size 7,562 → 2,836 words. Rendered role prompts to a 383-word mean against a 400 target — the only class inside its target. The corpus is steerable. It has been steered once.

**4,461 lines of working Python.** Lint, five compilers, artifact tools, two cost tools. They run. They would cost real time to rebuild.

**The honesty of the record.** Every waiver is disclosed in writing. An agent analysis on 2026-09-08 named `define-good-up-front` as the source of screen proliferation nine days before the same conclusion was reached at the top. This system diagnoses itself accurately and early, without being asked. That disposition made this analysis possible in roughly 11 working days of executed process. It is the asset most at risk from a restart.

## Limits of this analysis

- **No baseline and no comparator.** Nobody established what a 26-day definition corpus for a self-defining system normally looks like. The migration plan states no duration, week, or elapsed estimate. Every "too much / too slow" judgment here is unanchored, including the framing of the question.
- **The seed period has no defect record.** 72 of 278 commits (2026-08-22 to 09-01) produced no session records by explicit seed rule. There are 22 session records across 10 calendar days. The branch has roughly 11 working days of executed process, not 26. The rising defect rate is as consistent with "execution began 09-02" as with "the system is degrading".
- **Transcript-derived figures were not re-derived.** The 592 subagent runs, 3.18 billion cache-read tokens, 41% check-token share and 1,321 register items come from `~/.claude/projects`, outside the repository. They are the most confident numbers produced and the least verifiable.
- **Counts disagree between measurers.** "check" in `basis/processes` was reported as 611 and 693; bare sed/grep in process definitions as 30, 33, 41, 71 and 77; check-shaped steps as 19, 26, 27, 34 and 35. Treat any figure here that does not carry a command as directional.
- **The counterfactual the factor set demands was never run.** Nobody gave a fresh agent the 5 load-bearing obligations versus all 26 and scored the outputs. Every "cost with no yield" claim is inferred from adherence counts.
- **Nobody costed a restart, and nobody asked what was expected by day 26.** "Off course" presupposes a course that is not written down.

## What the evidence implies

The rebaseline's problem is not that it wrote too much. It is that almost nothing it wrote is held in place by anything but a sentence, and nothing outside the corpus reads back what the corpus says about itself. Those two facts are independent of prose, phase, plan and calendar. They are also the two facts the previous corpus on `main` carried, with counters attached. A second restart re-seeds from that corpus, discards a working compiler architecture, a working cold-review check, a measured steering result and the defect record that made this diagnosis possible — and leaves both facts untouched.

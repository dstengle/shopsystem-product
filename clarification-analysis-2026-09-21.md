# Every time you asked for clarification

Source: all 64 main-loop session transcripts in `transcripts/`, 2026-08-05 to
2026-09-17. Every human turn was read, not keyword-filtered. Duplicates from
mirrored sessions, compaction summaries, and boilerplate were removed.

## The numbers

327 unique turns you wrote. 75 of them asked for clarification, restatement,
simpler language, or said you were confused. **That is 23%, and it never
improved:**

| week | your turns | clarifications | rate |
|---|---|---|---|
| Aug 5–9 | 9 | 2 | 22% |
| Aug 10–16 | 10 | 4 | 40% |
| Aug 17–23 | 73 | 20 | 27% |
| Aug 24–30 | 42 | 10 | 23% |
| Aug 31–Sep 6 | 102 | 19 | 18% |
| Sep 7–13 | 47 | 8 | 17% |
| Sep 14–17 | 44 | 10 | 22% |

Three interventions landed in that period and none moved the rate: your base
writing style (Aug 14), the banned-word lint (Aug 25), and the plain-voice
initiative (Sep 8).

A second cost sits beside this one: 36 of your turns were process invocations
typed by hand ("Start a run of… Resume run lead-…"). You were operating the
router yourself.

## What you were reacting to

Each of the 75 was matched to the assistant text it answered. Seven patterns,
by count.

### 1. An invented term, used as if you already knew it — 24 of 75

The largest pattern by a wide margin. The assistant coins a word, then uses it
next turn as settled vocabulary. Examples, with who introduced the word:

| term | introduced | your reaction |
|---|---|---|
| seat | assistant, Aug 5 | "Why are we using the word seat? Is it any different than saying role?" |
| sitting, ruling | assistant, Aug 5/10 | "sitting is an awkward name that doesn't relate the purpose" |
| disposition, ratify | assistant, Aug 5 | "I do not want to use the word disposition, it is overly complicated" |
| rebaseline bill | assistant, Aug 19 | "bill, while it is something you pay is also awkward" |
| offer | assistant, Aug 5 | "What is an offer, that doesn't seem right?" (Sep 6) |
| governed channel | assistant, Aug 22 | "what is 'governed channel' and which process is it? … not in the glossary" |
| standing knowledge | assistant, Sep 6 | "This doesn't make sense to me. It seems like you are being vague" |
| ruling lane | assistant, Sep 4 | "please restate … in simpler terms, since I do not understand" |
| review budget, many flags | assistant, Sep 16 | "What do you mean by review budget and many flags?" |
| judge runner, traceability ceremony | assistant, Aug 6 (in a brief) | "concepts that have not been introduced previously" |
| R37, lead-kmrd4, F-codes | assistant | "an opaque reference" |

**25 of 25 terms traced were the assistant's.** The three that first appear in
your turns (judge runner, format slice, F-code) were you quoting a document the
assistant had written.

Five of these are now the entire banned-word list in `lint_basis.py`. The lint
is a blocklist of coinages you rejected one at a time. It cannot catch the next
one.

None was in the glossary when you asked. Several became corpus vocabulary
anyway: `offer` is in 30 basis files, `ruling` in 28, `route` in 52, `cap` in
58.

The clearest case is "the ask mechanism." You asked "Please explain the ask
mechanism" at 20:20 on Aug 25. No reply came for nine minutes. You asked again.
The answer opened: *"The ask mechanism is the name I gave, in the PM/PO report
and the three roles, to a capability the system doesn't have yet."* The term was
already written into three role definitions before it was explained to you or
existed.

### 2. You could not tell where you were, or what was being asked — 16 of 75

"I don't know what I'm approving, exactly." "It's not clear what process we're in
or how we got here." "Remind me how this request started." "Is there anything
actually waiting on me?" "What is the authority-approve verdict?" — that last one
is you asking what word you are supposed to say.

The assistant's replies assumed you held the whole state of the system in your
head between sessions. You did not, and could not. Nothing in a reply said: here
is the process we are in, here is the one decision, here are the words that
decide it.

### 3. One sentence carrying several conditions — 9 of 75

Where you quoted the text, it was always a sentence stacking clauses:

> "Phase 0 is done when the decision-record chain's authoring process runs
> end-to-end — with L0/L1/L2 projections emitted and consumed, under the updated
> PM/PO/Architect definitions — demonstrated on one real exemplar."

Four nested qualifications before the sentence resolves. Others: "review seats
audit conformance instead of supplying taste"; "whose attachment carries them
unprompted"; a quote nested inside a parenthetical inside a bullet.

This is the pattern the earlier analysis measured with sentence length and
found small. It is small: 9 of 75. The record says the problem was mostly
pattern 1, which sentence length cannot see.

### 4. A reference you could not resolve — 6 of 75

Bead ids, ruling numbers, and internal labels used in prose as if they were
words. "I don't know what lead-kmrd4 is, this is an opaque reference."

### 5. Your own words restated wrongly — 4 of 75

"I did not say that running system is a term for products that do not run as
servers." "'Forbidden to open the feature' was my compression of the lead-pm's
turn, not a quotation." Small count, high cost: each one was you defending your
own position against a record the assistant had already written.

### 6. No answer came — 4 of 75

Silence, or a reply with no prose because the assistant was working in tools.
"Why are you using bash tools to look at artifacts?"

### 7. A design question the artifact itself left open — 12 of 75

Genuine questions about the design, not the language: "How does feature
authoring co-produce with the shops?" "Why do we need co-production and the
three amigos?" These are the ones a product authority should be asking. They are
one in six of the total.

## The mechanism

The pattern has a loop, and the loop is why the rate never fell.

1. The assistant compresses a concept into a new noun to keep a reply short.
2. Next turn, it uses the noun as settled.
3. You ask. The explanation introduces two more nouns.
4. The noun gets written into a definition. Now it is corpus vocabulary and
   every future reader inherits the gap — agent and human.

Your base writing style of Aug 14 names this exactly: *"Never use a metaphor as
a technical term… Explain every insider reference… Assume the reader knows none
of our history."* It was applied to documents. It was never applied to the
assistant's replies to you — the channel where all 75 of these happened.

Your `use-defined-terms` principle of Aug 19 names it too. It was written as a
MUST in the principle set and enforced nowhere on conversation.

## What this changes about the language rule

The rule is not "shorter." The record says:

- **No noun that is not in the glossary or plain English, in any channel,
  replies included.** A coinage is a defect at first use, not after it reaches
  thirty files. The glossary is the allowlist; a blocklist of yesterday's
  coinages cannot work.
- **Every reply that needs a decision orients first:** the process, the one
  decision, the words that decide it. Sixteen of 75 were "where am I."
- **Quote, never restate.** Four of 75 cost you a correction of your own record.
- Sentence length is a minor factor. Measuring it will not find the problem.

## Every clarification, by pattern

### A. An invented term, used as if you already knew it — 24

- **2026-08-06** — The decision brief is an improvement but the decisions bring up concepts that have not been introduced previously, like "judge runner". Judge is mentioned several times but not judge runner. Traceability ceremony has …
- **2026-08-14** — What are these "format slice sections"? I'm confused if they belong in the actual final documents or not. I expect the readme to take me through an example set of documents as they would be in the system
- **2026-08-19** — Implications: I'm not sure about this section in general. For instance "checks that cannot cite their definition clause are deleted", why is this an "implication" instead of just another MUST statement? "review seats …
- **2026-08-19** — First thing here, why are we using "kind" rather than "type".  New principle: use-defined-terms - Important terms MUST be defined in the system. If choosing between terms to make a statement, a defined term MUST be us…
- **2026-08-21** — s/kind/type/  Yes, least context principle: Any given activity should be loaded with the minimum necessary context to accomplish the task. The process names what loads into the context and what sources they come from.…
- **2026-08-21** — bill, while it is something you pay is also awkward. Show me alternatives
- **2026-08-21** — Is this a one-off specifically for the work we are doing? For plan, what do you mean by per-record decision structure? It has been sufficiently long since this whole process started that the terminilogy and process ar…
- **2026-08-21** — I do not want to use the word disposition, it is overly complicated. Please rework the language.  Replace ratify with approve.  Give me alternatives for disposition
- **2026-08-22** — There is a lot of new markdown in the basis branch that is not represented in the README. I don't know what I'm approving, exactly. There is a definition-chain-migration and a definition-chain referenced type within t…
- **2026-08-23** — Where is "R37" going and what happens with these rulings? This is somewhat confusing and I'm not sure what process or artifact these belong with.
- **2026-08-25** — Why are we using the word seat? Is it any different than saying role?
- **2026-09-02** — In this scenario, small language change:  ```   @feature:feat-skills-availability @hash:8d591e6cf06a   Scenario: a hand-diverged skill is reconciled     Given a loadable skill edited by hand away from the loadable for…
- **2026-09-03** — What is the designer role's corpus records?
- **2026-09-04** — Configuration would be instance-local role and process decisions by the user "Add xxx to the lead-pm role locally" or operational changes like the runtime back-end of the bc shops, connection management for LLMs, etc.…
- **2026-09-05** — Keep exploring. My impression was that the typdef included everything including guidelines and fitness checks and those were just renderings. We need to get that in place (if not already) since it will be easier to ev…
- **2026-09-05** — What are the two remaining requests? Please refer to the as requests and not "routes"
- **2026-09-05** — "whose attachment carries them unprompted" is not clear
- **2026-09-06** — What is an offer, that doesn't seem right? Can you show me all of what the architect wrote?
- **2026-09-06** — "standing knowledge"... This doesn't make sense to me. It seems like you are being vague and making assumptions. Please think about the implications of this and get back to me.
- **2026-09-06** — What is meant by nothing else is independent?
- **2026-09-09** — No-gos: What is "no second home for a rendering or install"? That seems open to interpretation
- **2026-09-16** — Where is needs-decision coming from? I don't see that string anywhere in the basis directory
- **2026-09-17** — What do you mean by review budget and many flags? ADRs should not be held for my review at all. I do not gate all decisions. Once I commit to a bet, I want to see it done and not be involved. Anything I do will be spo…
- **2026-08-19** — change projection to rendering

### B. One sentence carrying several conditions — 9

- **2026-08-22** — risks: 1) I generally agree, but the sentence "Phase 0 is done when the decision-record chain's authoring process runs end-to-end — with L0/L1/L2 projections    emitted and consumed, under the updated PM/PO/Architect …
- **2026-08-22** — Please re-word the second paragraph to make it easier to understand
- **2026-09-07** — Can you restate the open check I would order first? Simplify the the sentences. I think I might understand but I want it restated.
- **2026-08-23** — The operational history modifications are good.  For the actual principles, the originals on main read better in terms of the statements, in particular, the local-comprehension and intent-provenance have been shortene…
- **2026-08-23** — Before we move on would the principles be easier for human and agent to understand if they were structured with bullets rather than a single line of sentences and clauses?
- **2026-09-10** — Explain the sequencing question.
- **2026-09-02** — Regarding the cost of authored levels, what artifacts are being amended frequently that need to be in the context? Decisions should be frozen once they are accepted and then replaced by new decisions when they are sup…
- **2026-08-19** — In the stakeholder process, the continuity of the decision-brief artifact flowing through is unclear. A "delivery" appears to be a boolean status structure, not the result.
- **2026-08-25** — Why is the typedef necessary. Do we actually use that distinction anywhere right now? I like the intent, but this seems like a thing that is important to processes and should be fleshed out further when it actually ma…

### C. You could not tell where you were or what was being asked of you — 16

- **2026-08-10** — I am not clear on ask 0 what changes I might be committing to regarding existing formats, or are these just net new format definitions? We already have an artifact schema system, for instance.   In the skills, one act…
- **2026-08-19** — Remind me of the roadmap we are executing against. My understanding was that we are going to do a lot of trimming to be able to re-start with the new basis. Is this incorrect?
- **2026-08-19** — I am unclear as to when the artifact skills will be created so that the new artfifacts are re-written to a standard. The reason for this exercise is that the typdefs and existing "skills" were simple format examples a…
- **2026-08-22** — The word "kind" is still used in the doc instead of type.  The F-codes are not sufficiently explained. I don't understand where my review input is with each artifact that is migrated. It looks as if *many* artifacts a…
- **2026-08-22** — Phase 0: I must have assumed that the principles + framework spec were one and the same. Can the migration proceed without the framework spec? Will this result in anything proceeding without a definition of what good …
- **2026-08-23** — I'm not sure if I get the difference between the two. There isn't a single "interview" There should be an interview for the PD feature and then further interviews based on the inventory/census as features get pulled i…
- **2026-08-27** — Where does our brief artifact fit? I've been a little confused on the term brief vs how we are using it in the product management lifecycle  Can we get a cold read of the entire system from a product leadership person…
- **2026-08-28** — I thought brief was being replaced by initiative, but I don't see a definition for that
- **2026-08-30** — What process is a decision brief used in? I understand the point of the document and it is logical place to use it, but it's not clear what process we're in or how we got here. I'm fine if it is a more generic process.
- **2026-09-03** — Is there anything actually waiting on me? it looks like the .claude/agents has been rendered
- **2026-09-04** — Please explain Ask 3 in simple terms  Ask 4 - this sounds like something the architect should just do without even asking. Why would it wait? Is it due to initiative definition?
- **2026-09-04** — What does it mean Asks 1 and to on brief-034 - why did you bring that up?
- **2026-09-16** — What is the authority-approve verdict?
- **2026-09-16** — Remind me how this request started, what is the opening statement? We have a lot of things in flight
- **2026-09-16** — Also - what role is this now? I thought discovery would be the lead-pm. Why is the lead-pm running as a subagent?
- **2026-08-31** — Leave it as is.  Looking through brief-032, what are the specifics of what the architect and designer are contributing to the initiative-check?

### D. A reference you could not resolve — 6

- **2026-08-22** — The fabro-dogfood was definitely overridden but not recognized that way: retire.   The lead-shop code ownership boundary will definitely surface again and require a decision: retire  I'm not sure what the agent-vault …
- **2026-09-16** — What will the attribute consist of in the schema?
- **2026-08-11** — I still see a lot of text in html5 comments. What is that for?
- **2026-08-11** — The basis/ files are somewhat difficult to read through. I need you to make the Readme a walkthrough show and tell with proper links to the different files and an explanation of where they would come into play. Also, …
- **2026-08-06** — Given that this is one of the up-front areas where I want to be more involved in reviewing decision, I don't see how I can read an 8000 word document. This is not accessible to me. One of the very first skills we need…
- **2026-08-21** — How is migration plan innaccurate here?

### E. Your own words restated wrongly — 4

- **2026-09-09** — split request ammendment: please explain this whole section further. I did not say that running system is a term for products that do not run as servers
- **2026-09-16** — Two things:   Why isn't all of this referencing the initiative where the need for an adr comes from in the first place instead of copying text around.  Second, what is this about the author is forbidden to open the fe…
- **2026-09-06** — The architect can "do this" as in do the full architecture workup, but that looks inappropriate in a feasibility section. The "Work" section looks like task level work that belongs somewhere else but probably doesn't …
- **2026-09-04** — Ask 3, my wording should change. The lead-pm should be catching these and recommending I change something that is so early in the process. the discovery process needs additional reinforcement about problems vs solutio…

### F. No answer came — 4

- **2026-08-25** — Please explain the ask mechanism
- **2026-08-25** — Explain the ask mechanism
- **2026-09-02** — Regarding the cost of authored levels, what artifacts are being amended frequently that need to be in the context? Decisions should be frozen once they are accepted and then replaced by new decisions when they are sup…
- **2026-09-16** — Why are you using bash tools to look at artifacts?

### G. A design question the artifact itself left open — 12

- **2026-08-25** — Can you expand more on the second statement about accountability?
- **2026-08-27** — BC-shops are component teams Explain the difference of framing being checked inside the initiative or on its own? Where would the framing live otherwise?  PO types need guidelines in order to be complete  Add feasibil…
- **2026-08-27** — The acceptance-scenarios-typdef looks very different from what I've seen before. First, how are they grouped together? What is their reason for existing. BDD typically has a feature with scenarios. Second, the scenari…
- **2026-08-31** — How does feature authoring co-produce with the shops?  The designer add criteria. Does the architect get any contribution? How is technical guidance delivered or accounted for in the system and activities?
- **2026-08-31** — Why do we need co-production and the three amigos? What is the value the shop brings in writing new scenarios? Steps are written by the shop as part of the implementation of the scenario. They are code and internal to…
- **2026-09-07** — Prose is missing as a top level issue. Much of the text is both much too verbose and much too complex for the job at hand. We need to define a voice that is straightforward and rejects complexity and excessive verbosi…
- **2026-09-09** — Regarding the rollup change, was there a change in the feature contract? Why did we lose information?
- **2026-09-09** — Is the cost per execution at the process/sub-process level and therefore the build would roll up into an initiative?
- **2026-09-10** — Before we make any changes, how would a demonstration work? I could be comfortable leaving it on the implementer, but demonstrating is not defined and there is no process for it. I like the idea of scenarios and featu…
- **2026-09-16** — Please explain the first choices more clearly. The decisions should be available to the shop.
- **2026-09-17** — Is the session record something that could be mechanical? What is the router doing that involves any judgement?
- **2026-09-04** — So, given that there is a very specific, non-solution statement of the problem, where is the statement of the solution for the problem?

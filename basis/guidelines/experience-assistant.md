---
type: quality-guideline
id: experience-assistant-guideline
target-type: interaction
interaction-type: assistant
owner: product-authority
status: draft
version: 3
created: 2026-08-26
updated: 2026-08-26
---

# Guideline: conversational, voice, and assistant interactions

**Voice principle.** Write the assistant for the person who states
what they want and needs to know, at every turn, what the product
understood, what it can do, what it is about to do, and how to stop
it.

**Highlights (the layer compiled into generating context):** say what
you can do, and disambiguate rather than guess · state and confirm
before the hard-to-reverse · correct, dismiss, stop — at any turn ·
the spoken form stands alone; every option reachable by voice and on
screen · a repair turn narrows, then offers, then hands off · one
persona in the corpus's voice.

**Layers:** this guideline covers the assistant interaction type
(`assistant`: conversational, voice, and an assistant acting for the
person) and layers its idiom on the common experience guideline. Its
platform guidelines, named by the corpus: Microsoft's Guidelines for
Human-AI Interaction — eighteen guidelines cited below by number as
HAX G1–G18; Google's conversation design guidelines, resting on
Grice's cooperative principle; Amazon's Alexa design guide for
multimodal parity; Google's People + AI Guidebook (PAIR) for errors
and control. Where they differ, HAX governs control, Google
conversation design governs dialogue, Alexa governs modality parity.
Precedence when rules conflict: an approved principle beats the
[quality-guideline typedef](../artifacts/quality-guideline.md), which
beats the [common experience guideline](experience-common.md), which
beats this one; the base writing style is never overridden. Every rule
feeds scenario 6 of the
[interaction fitness set](../fitness/interaction.fitness.md), judged by
the product designer role, and names the principle bullet or the
corpus-named platform guideline (through `consistent-not-uniform`
bullet 2) it derives from.

---

## Rules

**1. State capability; disambiguate rather than guess.**
Before: an assistant that answers every request as if it could do it.
After: an opening and a help turn that say what the assistant can do;
an answer that asks when it is unsure ("I found two matches; which did
you mean?").
*Test:* ask the assistant what it can do; ask something outside its
scope; ask something ambiguous. *Criterion:* it names its capabilities;
it declines out-of-scope requests with the nearest thing it can do; it
asks rather than guessing. *Decision:* yes/no per assistant.
*Derived check:* judged — interaction fitness scenario 6;
`control-stays-with-the-person` bullet 1; HAX G1, G2, G10 via
`consistent-not-uniform` bullet 2.

**2. State and confirm before the hard-to-reverse.**
Before: "Done — I've cancelled your subscription." with no prior turn.
After: "This cancels the subscription now and cannot be undone. Go
ahead?"
*Test:* trigger each action the corpus classes as hard to reverse.
*Criterion:* every such action is stated and confirmed before it runs.
*Decision:* yes/no per action.
*Derived check:* judged — interaction fitness scenario 6;
`control-stays-with-the-person` bullet 2; HAX G16.

**3. Correct, dismiss, stop — at any turn.**
Before: an assistant that cannot be interrupted mid-task and offers no
way to undo what it just did.
After: "stop" halts the current action; "no, I meant…" re-routes; the
last action can be undone or its result edited.
*Test:* interrupt a multi-step action; correct a misunderstanding;
dismiss an unwanted suggestion; undo the last action. *Criterion:* each
works at any turn and the assistant confirms what it stopped or
changed. *Decision:* yes/no per assistant.
*Derived check:* judged — interaction fitness scenario 6;
`control-stays-with-the-person` bullet 3; the undo, HAX G9 via
`consistent-not-uniform` bullet 2.

**4. The spoken form stands alone; every option reachable both ways.**
Before: a screen prompt with five choices and a spoken prompt that
names two.
After: the spoken prompt carries the core message on its own; every
choice shown on screen is speakable, and every choice spoken is
selectable on screen.
*Test:* compare each turn's spoken and displayed forms. *Criterion:*
the spoken form stands alone without the screen; the two carry the
same core message; every option is reachable in both. *Decision:*
yes/no per turn.
*Derived check:* judged — interaction fitness scenario 6;
`core-task-parity` bullet 2 within the type (bullet 1 across types is
the common guideline's rule 4); Alexa "be multimodal" and Google
"scale your design" via `consistent-not-uniform` bullet 2.

**5. A repair turn narrows, then offers, then hands off.**
Before: "Sorry, I didn't get that." repeated three times.
After: a first repair that narrows ("Did you mean the invoice from
March or April?"), a second that offers the choices, a third that
hands control back ("I'll show you the list instead.").
*Test:* give unrecognised, ambiguous, and out-of-context input.
*Criterion:* each repair turn adds information and the third hands
control to a non-conversational path (the message's content is the
common guideline's rule 3). *Decision:* yes/no per assistant.
*Derived check:* judged — interaction fitness scenario 6;
`control-stays-with-the-person` bullet 4; PAIR "errors and graceful
failure" via `consistent-not-uniform` bullet 2.

**6. One persona in the corpus's voice.**
Before: an assistant chatty on one turn and clipped on the next.
After: the persona the corpus defines; tone varied to the person's
state within one personality; the assistant never presents itself as a
person.
*Test:* read a full dialogue against the corpus's persona. *Criterion:*
the personality is constant while tone varies; the assistant does not
claim to be a person. *Decision:* yes/no per dialogue.
*Derived check:* judged — interaction fitness scenario 6; Google
conversation design's persona guidance and HAX G5 via
`consistent-not-uniform` bullet 2 (vocabulary is the common
guideline's rule 1).

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored by owner direction as the second layer of the experience guidance corpus, applying the approved experience principles to assistant interactions. |
| 1 | 2026-08-26 | review | Screened with the other four: findings — accessibility absent though the principle names the type; core-task bullet 1 uncovered; HAX and PAIR undefined; authoring order in rule 4; rule 2's "act freely" added an obligation; the persona and never-a-person clauses unsourced. |
| 2 | 2026-08-26 | update | Repairs: layered on the common guideline, which carries accessibility and cross-type core tasks; HAX and PAIR introduced in Layers with precedence; rule 4 decided on the delivered forms; rule 2 reduced to the principle; rule 6 sourced and inactive until the persona exists; every derived check names the interaction fitness set. |
| 2 | 2026-08-26 | review | Re-screened: rule 6 marked inactive while rule 2 depended on an equally absent record unmarked. |
| 3 | 2026-08-26 | update | the state removed; both depend on records the common guideline lists with the absent-record verdict. |
| 3 | 2026-08-26 | review | Final screen (round 3): clean — every rule decidable with a named scenario and derivation; two line edits and three optional stumbles polished in place. |

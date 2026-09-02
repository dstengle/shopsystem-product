---
type: quality-guideline
id: adr-guideline
target-type: adr
owner: product-authority
status: approved
approved: 2026-09-02
version: 1
created: 2026-09-02
updated: 2026-09-02
---

# Guideline: adr

**Voice principle.** Write the record for the role that, a year from
now, must design against this decision or undo it: one decision, the
forces and options that were real, what it bounds and what it costs,
who held the right, how the decision stands against the architecture
principles, and what would bring it back for review — readable in one
sitting.

**Highlights (the layer compiled into generating context):** a
one-line title and exactly one decision, as a sentence someone can act
on · context with the evidence and at least one real option with the
reason against it, or the statement that none was real · consequences
priced: what changes, for whom, at what cost — a bound on Bounded
Context shops stated as one · the deciding role and its right, or the
escalation · reversibility and its trigger · the
architecture-principles screen's result stated.

**Layers:** this guideline adds adr rules on top of the
[base writing style](base-writing-style.md); the base always applies
and is never overridden. When rules conflict, an approved principle
beats the [adr typedef](../artifacts/adr.md), which beats this
guideline. Every rule feeds the
[adr fitness set](../fitness/adr.fitness.md), scored in the
[adr-authoring](../processes/adr-authoring.md) process.

---

## Rules

**1. One decision, one-line title.**
Before: a title that narrates — "Direct grant from the rights holder
authorizes ingestion, resolves within an earlier record's second
decision, does not overturn its first" — over a record carrying three
numbered sub-decisions.
After: title "Registry addresses replace filesystem paths"; one
decision sentence; the other decisions split into their own linked
records.
*Test:* read the title and count the decisions in the decision
sentence. *Criterion:* the title is one line naming the decision;
exactly one decision, and a reader can say what to do differently
tomorrow because of it. *Decision:* yes/no per record.
*Derived check:* judged — adr fitness scenario 1.

**2. Context carries the evidence and the real options.**
Before: "The current approach has problems, so we considered
alternatives."
After: "Every CLI invocation takes `--bc-root <path>`; in a
containerized Bounded Context that path resolves only on the lead's
host. Option: bind-mount the lead's filesystem into every container —
declined because the mount re-couples what containerization
decouples."
*Test:* read the context. *Criterion:* forces and pre-state stated
with their evidence, and either one option the deciding role could
have chosen with the reason against it, or the statement that no
other option was real. *Decision:* yes/no per record.
*Derived check:* judged — adr fitness scenario 2.

**3. Name the decider and the right.**
Before: "After discussion it was agreed that…"
After: "Decided by the solutions architect role under its guardrail
right." — or, where the authority settled it, the escalation named in
the context.
*Test:* read the frontmatter `decided-by` and `right`, and §1 where
`right` is `escalation`. *Criterion:* the role and the decision right
are named, or the escalation that settled it is. *Decision:* yes/no
per record.
*Derived check:* judged — adr fitness scenario 3.

**4. Price each consequence; state a bound as a bound.**
Before: "This will affect the messaging layer and possibly the shops."
After: "Shops address each other by registry name: the messaging
contract gains a lookup (one contract version); Bounded Context shops
MUST NOT address a shop by filesystem path — a bound; cost — every
existing dispatch script updates once."
*Test:* for each consequence, find what changes, for whom, and what it
costs or forecloses; where it constrains Bounded Context shops, find
the bound stated as one. *Criterion:* all parts present. *Decision:*
yes/no per consequence.
*Derived check:* judged — adr fitness scenario 4.

**5. Say how hard it is to undo, and what would bring it back.**
Before: nothing on reversibility.
After: "Reversible until a second Bounded Context ships against the
registry; after that, hard — reopened only if the registry becomes a
single point of failure in operation."
*Test:* read the reversibility section. *Criterion:* it states the
difficulty and, for a hard-to-reverse decision, the trigger that
reopens it. *Decision:* yes/no per record.
*Derived check:* judged — adr fitness scenario 5.

**6. State the principles screen's result.**
Before: silence on the architecture principle set, the deviation
absorbed.
After: "Screened against the architecture principle set: conforms." —
or "Screened: cannot satisfy `<principle>`; the exception is escalated
to the authority and named here."
*Test:* find the screen statement. *Criterion:* the result is stated —
conformance, or the named principle with its escalation. *Decision:*
yes/no per record.
*Derived check:* judged — adr fitness scenario 6.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-09-02 | update | Authored through the definition-chain-migration process to complete the adr chain; each rule maps to one fitness scenario; before/after material drawn from the autopsy of the frozen corpus's keepers (the registry decision and the rights-grant record). |
| 1 | 2026-09-02 | state | draft → approved by the owner with the chain (brief-033 ask 1). |

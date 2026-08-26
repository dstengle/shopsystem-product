---
type: quality-guideline
id: experience-api-guideline
target-type: interaction
interaction-type: api
owner: product-authority
status: draft
version: 3
created: 2026-08-26
updated: 2026-08-26
---

# Guideline: API, SDK, and agent tool interactions

**Voice principle.** Write the interface for the caller — a developer
reading the reference at two in the morning, or an agent reading the
tool definition with nothing else — so that the name says what it does,
the documentation says what will happen, and the error says what to do.

**Highlights (the layer compiled into generating context):** names for
the caller · behaviour stated, including omitted inputs, the return,
and each failure · a stable, documented code beside every error's
explanation · retry safety documented · no agent-only capability.

**Layers:** this guideline covers the API, SDK, and agent
tool-definition interaction type (`api`) and layers its idiom on the
common experience guideline. Its platform guidelines, named by the
corpus: Google's API Improvement Proposals for resource naming and
standard methods; the Azure REST API guidelines for compatibility and
error shape; Anthropic's guidance on the agent-computer interface for
tool definitions — where they differ, AIP governs naming, Azure the
error shape, Anthropic the tool definition. What is promised — the
contract, including whether an operation is idempotent — is the
solutions architect role's; this guideline governs how the promise
reads to its caller. Precedence when rules conflict: an approved principle beats the
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

**1. Name for the caller.**
Before: a tool parameter `tgt_ctx_id` and a method `procRq2`.
After: `target_context` and `submit_request`, named with the corpus
vocabulary.
*Test:* read each name without its implementation. *Criterion:* a
caller can say what it is or does from the name and the vocabulary
alone; abbreviations appear only when the vocabulary records them.
*Decision:* yes/no per name.
*Derived check:* judged — interaction fitness scenario 6;
`agent-is-a-user` bullet 1 ("named for its caller"); AIP naming via
`consistent-not-uniform` bullet 2.

**2. State the behaviour, including what it does not do.**
Before: "Updates the record."
After: "Replaces the record's mutable fields with the values given;
fields omitted are left unchanged; returns the record as stored.
Fails with `not_found` if the id is unknown. Safe to retry: yes — a
replay returns the stored record unchanged."
*Test:* read each operation's documentation. *Criterion:* it states
the effect, the treatment of omitted inputs, the return, each failure
case with its error, and whether a retry is safe and what a replay
returns. *Decision:* yes/no per operation.
*Derived check:* judged — interaction fitness scenario 6;
`agent-is-a-user` bullet 1 ("its behavior stated in its
documentation").

**3. A stable code beside the explanation.**
Before: `{"error": "E4031"}`
After: `{"code": "quota_exceeded", "message": "The workspace has used
its 500 requests for today; the limit resets at 00:00 UTC.", "next":
"Retry after the reset or raise the limit in workspace settings."}`
*Test:* trigger each documented failure. *Criterion:* the response
carries a stable code from a documented, closed set beside the
explanation and next step the common guideline's rule 3 requires.
*Decision:* yes/no per error.
*Derived check:* judged — interaction fitness scenario 6; Azure error
shape via `consistent-not-uniform` bullet 2. `errors-guide-recovery`
bullet 2 permits an identifier alongside; an agent needs the code, so
this type requires one — a tightening the principle allows; the
explanation, interaction fitness scenario 3.

**4. Nothing only an agent can do.**
Before: a tool `bulk_purge` with no counterpart in any interaction a
person uses.
After: the same capability offered through a person-facing interaction
type, or the tool withdrawn.
*Test:* list each agent-facing operation against the person-facing
interaction types. *Criterion:* every capability is reachable by a
person through some interaction type. *Decision:* yes/no per
operation.
*Derived check:* judged — interaction fitness scenario 6;
`agent-is-a-user` bullet 2.

## Document History

| Version | Date | Kind | Entry |
|---|---|---|---|
| 1 | 2026-08-26 | update | Authored by owner direction as the second layer of the experience guidance corpus, applying the approved experience principles to API, SDK, and agent tool-definition interactions. |
| 1 | 2026-08-26 | review | Screened with the other four: findings — rule 4 obliged contract behaviour the Layers disclaimed; rule 6 had no principle and an undecidable criterion; rule 2's last clause undecidable; derived checks named no existing check. |
| 2 | 2026-08-26 | update | Repairs: layered on the common guideline; idempotency reduced to documentation of retry safety (rule 2) with the obligation left to the architect; "reveal power gradually" removed and noted for the owner as a principle candidate; rule 3 recorded as this type's variation on identifiers; every derived check names the interaction fitness set and its derivation. |
| 2 | 2026-08-26 | review | Re-screened: rule 2's After failed its own criterion; a capitalised keyword in a quotation; rule 3 called a permitted tightening a variation. |
| 3 | 2026-08-26 | update | replay result stated; keyword paraphrased; rule 3 named a tightening the principle allows. |
| 3 | 2026-08-26 | review | Final screen (round 3): clean — every rule decidable with a named scenario and derivation; two line edits and three optional stumbles polished in place. |

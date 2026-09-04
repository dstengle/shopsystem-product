---
name: discovery-conversation
description: "Conduct a bounded discovery dialogue in a declared form \u2014 brainstorm\
  \ (the first form), interview, or review of evidence \u2014 opened on a topic, or\
  \ on a request routed to it: the authority explores direction with the lead-pm as\
  \ interlocutor, nothing is operationalized before convergence, the session record\
  \ anchors the conversation, and a converged discovery leaves an initiative recorded\
  \ `proposed` \u2014 or `proposed` and then `cancelled` in the same document when\
  \ what was asked is declined, so the record of the decline survives."
type: skill
id: discovery-conversation-skill
status: approved
created: 2026-08-22
updated: 2026-09-04
generated: true
generated-by: basis/tools/compile_process.py
derived-from: discovery-conversation-process
source: basis/processes/discovery-conversation.md
source-digest: sha256:ac0804bd4704
---

# Discovery conversation (compiled from `discovery-conversation-process`)

Conduct a bounded discovery dialogue in a declared form — brainstorm (the first form), interview, or review of evidence — opened on a topic, or on a request routed to it: the authority explores direction with the lead-pm as interlocutor, nothing is operationalized before convergence, the session record anchors the conversation, and a converged discovery leaves an initiative recorded `proposed` — or `proposed` and then `cancelled` in the same document when what was asked is declined, so the record of the decline survives.

**Engage the authority's statements as an interlocutor; record and launch only after convergence.**

Result of a run: `initiative` (string).

```mermaid
flowchart TD
  open["Open the work item — runtime<br/>in — topic: string, form: string, request: string"]
  observe[["Authority explores — human: product-authority<br/>in — topic: string<br/>out — statement: string, classification: string"]]
  route{"Route on the input<br/>in — classification: string"}
  engage(["Engage as interlocutor — agent: lead-pm<br/>in — statement: string, classification: string, form: string, initiative_draft: string, request: string<br/>out — reply: string, initiative_draft: string"])
  handoff{{"Close onto the session record — sub-process: session-handoff-process<br/>out — session_record: session-record"}}
  route_frame{"Route on what the close carried<br/>in — classification: string"}
  frame(["Record the initiative — agent: lead-pm<br/>in — session_record: session-record, initiative_draft: string, request: string<br/>out — initiative: string, request: string"])
  close_out["Close the work item — runtime<br/>in — session_record: session-record"]
  cancel_out["Cancel the conversation — runtime<br/>in — statement: string"]
  __end(("end<br/>result — initiative: string"))
  __start(("start")) --> open
  open --> observe
  observe --> route
  route -->|success exit: converge or close — hand off| handoff
  route -->|cancel exit: authority cancels| cancel_out
  route -->|else| engage
  engage --> observe
  handoff --> route_frame
  route_frame -->|converged — frame the initiative| frame
  route_frame -->|else| close_out
  frame --> close_out
  close_out --> __end
  cancel_out --> __end
```

## open — Open the work item

Run by the runtime — no agent, no prose. reads: topic, form, request · writes: —.

```yaml
run: "title=\"Discovery conversation (${form}): ${topic}\"\nif [ -n \"${request}\"\
  \ ]; then\n  title=\"$title \u2014 request $(sed -n 's/^id: //p' \"${request}\"\
  )\"\nfi\nbd create --title \"$title\"\n"
next: observe
```

## observe — Authority explores

Run by a human holding role `product-authority`. reads: topic · writes: statement, classification.
- then: `route`

Prompt:

```text
Think out loud. Your message is one of: a direction or exploration
to engage, a question, a convergence (the direction is settled —
record and route it), a close, or a cancel. Silence holds the
conversation after the declared window; the draft record carries
the resume point.
```

## route — Route on the input

Run by the runtime — no agent, no prose. reads: classification · writes: —.

```yaml
branches:
- label: "success exit: converge or close \u2014 hand off"
  when: classification in ["converge", "close"]
  next: handoff
- label: 'cancel exit: authority cancels'
  when: classification == "cancel"
  next: cancel-out
- else: engage
```

## engage — Engage as interlocutor

Run by an agent in role `lead-pm`. reads: statement, classification, form, initiative_draft, request · writes: reply, initiative_draft.
- check: `reply != ""`
- then: `observe`

Prompt:

```text
Engage the statement as an interlocutor, shaped to the declared
form — brainstorm: diverge into options before any convergence;
interview: draw out and quote the originator's own words; review
of evidence: read the record against its sources. Probe, reflect
back, name tensions with what is already decided, and offer
options with a recommendation when a decision is near. Do not
operationalize — no launching work, no writing definitions, no
dispatches — before the authority converges. Capture select
quotes into the draft session record, and maintain
initiative_draft — the initiative's Framing, For whom, and
Appetite sections, drafted from the authority's words — as the
dialogue moves. When request is set, the Framing's source is the
request's section 1 (What is requested — the originator's words),
quoted with the request's id as the reference, not the
transcript; the dialogue refines the direction, never the record
of the ask.
```

## handoff — Close onto the session record

Run by the runtime — no agent, no prose. reads: — · writes: session_record.

```yaml
next: route-frame
```

## route-frame — Route on what the close carried

Run by the runtime — no agent, no prose. reads: classification · writes: —.

```yaml
branches:
- label: "converged \u2014 frame the initiative"
  when: classification == "converge"
  next: frame
- else: close-out
```

## frame — Record the initiative

Run by an agent in role `lead-pm`. reads: session_record, initiative_draft, request · writes: initiative, request.
- then: `close-out`

Prompt:

```text
Assist step. From the session record and initiative_draft,
write the initiative per its typedef: the
Framing with the originator quoted, For whom with one measure,
Appetite with its no-gos; Feasibility and usability and
Decomposition "not yet"; Features empty; status "proposed",
owner lead-pm. When request is set: write the initiative's
`request` frontmatter link to it; quote the originator's words
in the Framing from the request's section 1, each quotation
carrying the request's id as its reference; then record on the
request where its route led — `routed-to` linking the
initiative, section 4 (Result) naming the initiative by id, and
status "done", the request typedef's writer rule for that
status. Where the conversation declined what was asked,
record the initiative "proposed" and cancel it in the same
document with the authority's reason, so the record of the
decline survives; state in the cancellation entry that the
product decision record for the decline is the PO role's to
make and the PO output check screens it, linked once made — the
initiative typedef's rule. Return the initiative's path.
```

## close-out — Close the work item

Run by the runtime — no agent, no prose. reads: session_record · writes: —.

```yaml
run: 'bd close --reason "Discovery closed onto ${session_record.id}"

  '
next: end
```

## cancel-out — Cancel the conversation

Run by the runtime — no agent, no prose. reads: statement · writes: —.

```yaml
run: 'bd close --reason "Discovery cancelled: ${statement}"

  '
next: end
```

---
name: eol-message
description: Empathetic end-of-life announcement for a retiring product or capability — acknowledges disruption, explains the change as progress, and gives a concrete migration path. Reach for it inside a product-narrative session, and specifically when a brief flips to status:retired.
---

# End-of-Life Message (PM technique skill — adapted, EXPERIMENTAL)

**Serves:** product-narrative · **Emits into:** README / site / current-state; ALSO used when RETIRING a capability (a brief flips to `status: retired`)

A *technique skill* (PDR-033): a lens invoked INSIDE the `product-narrative` PM session; its text lands in the README / site / current-state. It is a narrative lens, NOT a standalone announcement artifact.

*Adapted from [`deanpeters/Product-Manager-Skills/skills/eol-message`](https://github.com/deanpeters/Product-Manager-Skills/tree/main/skills/eol-message) — fetched live 2026-07-10. Adaptation rules + experimental status: [`../README.md`](../README.md).*

## Why the session reaches for this

Retiring a capability is a narrative act, not a terse shutdown notice. This skill
frames the retirement as progress while honestly owning the disruption, so the
current-state narrative reads as *"we value you enough to help you transition,
and here's specifically how"* — not as abandonment. It is the deprecation
counterpart to `press-release`.

## The structure (draft these)

1. **Context** — who we are, our continued commitment.
2. **Clear announcement** — what is being retired, and its replacement.
3. **Customer-focused rationale** — the benefit of the change, not "reduces our costs."
4. **Acknowledgment** — recognize what the retired capability did well.
5. **Impact** — honestly name what breaks for the user.
6. **Transition** — the replacement, with continuity messaging.
7. **Support** — migration help and resources.
8. **Timeline** — concrete dates, never "soon."
9. **Next steps** — clear calls to action and contact.

## Retain the round-trip (PM mode is interactive)

The rationale, replacement, timeline, and support plan must all exist *before*
drafting — an EOL written without them reads as abandonment. Elicit each from the
product authority one at a time; where a piece is missing, that gap is the
blocker to surface, not a blank to paper over.

## The retirement trigger

When a **brief flips to `status: retired`**, this skill produces the announcement
narrative that accompanies the flip. The retirement decision itself belongs
upstream (option-tradeoff / prioritization); this skill only voices it.

## Consumer / framework-as-product fork

- **Consumer:** announces a product/feature sunset to end-customers, with a real
  migration path.
- **Framework-as-product (bootstrap):** announces a deprecated shopsystem
  capability (a retired ADR/PDR pattern, a sunset message type) to
  adopters/operators, pointing at the successor. The framework's own deprecation
  notes are this fork's home instance.

## Lands in current-state / README

The finished message is woven into the product narrative on the README / site /
current-state. Pitfalls to reject: business-centric framing, vague timelines,
absent support plan, ignored impact, defensive or terse tone.

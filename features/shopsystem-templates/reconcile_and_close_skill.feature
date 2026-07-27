@bc:shopsystem-templates @origin:lead-t96cf
Feature: shop-templates pours a reconcile-and-close skill whose executable wrapper atomically consumes a BC work_done and closes its bead

  Directive (product authority, lead-t96cf): shop-templates pours a
  reconcile-and-close skill — like the write-<kind> writing skills — AND, because
  a prose SKILL.md cannot itself GUARANTEE atomicity across two steps, an
  executable "reconcile-and-close" wrapper in the shop ops surface (parallel to
  the "bc-emit" work-done wrapper) that the poured skill INVOKES. The wrapper
  performs "shop-msg consume" (of a BC work_done outbox row) AND "bd close" (of
  the corresponding bead) as ONE atomic reconcile-and-close action with fail-safe
  ordering: on a partial failure it rolls back the step that did complete, so a
  consumed work_done can never be left with an open bead (the consume-not-equal-
  close drift) and a closed bead can never be left with an unconsumed row. The
  wrapper is templates-owned: it composes the existing "shop-msg consume" and
  "bd close" primitives and needs no messaging-side or beads-side change. Scope
  is JUST the consume+close wrapping: the materialized bead->commit edge and the
  drift-audit are a separate follow-on and are NOT pinned here.

  @scenario_hash:df1fb287fcaad8e8
  Scenario: bootstrapping a lead shop pours the reconcile-and-close skill and its executable wrapper as a lead skill-group member
    Given an existing git repository at a target directory "/tmp/example-lead-shop" with no ".claude/skills/" directory
    When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "shopsystem-product", and target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And the target directory contains a file at ".claude/skills/reconcile-and-close/SKILL.md"
    And bootstrap also pours an executable "reconcile-and-close" wrapper into the shop ops surface, parallel to the "bc-emit" work-done wrapper
    And the content of ".claude/skills/reconcile-and-close/SKILL.md" names invoking that executable "reconcile-and-close" wrapper — which performs "shop-msg consume" of a BC "work_done" outbox row and "bd close" of the corresponding bead as one atomic reconcile-and-close action — rather than instructing the operator to run the two steps by hand

  @scenario_hash:42ef65d3056365f9
  Scenario: invoking the executable reconcile-and-close wrapper consumes the work_done outbox row and closes the corresponding bead together
    Given a consumable BC "work_done" outbox row for a work_id and a corresponding OPEN bead for that same work_id
    When the executable "reconcile-and-close" wrapper is invoked for that work_id
    Then the "work_done" outbox row is consumed and no longer appears in "shop-msg pending outbox"
    And the corresponding bead for that work_id is closed

  @scenario_hash:8ea8e48e7db32d88
  Scenario: the executable reconcile-and-close wrapper does not half-complete when the bd close fails — the work_done outbox row is left unconsumed
    Given a consumable BC "work_done" outbox row for a work_id and a corresponding bead whose "bd close" will fail
    When the executable "reconcile-and-close" wrapper is invoked for that work_id
    Then the pair does not half-complete: the "work_done" outbox row remains unconsumed and still appears in "shop-msg pending outbox"
    And no consumed-but-open drift results — the wrapper's fail-safe ordering leaves the outbox row present precisely because the close did not succeed, rolling back any partial consume rather than leaving a consumed row alongside an open bead

  @scenario_hash:06d1d6f03477e994
  Scenario: the executable reconcile-and-close wrapper does not half-complete when the work_done consume fails — the corresponding bead is left OPEN
    Given a work_id whose corresponding bead is OPEN and whose BC "work_done" outbox row cannot be consumed, so the "shop-msg consume" step fails
    When the executable "reconcile-and-close" wrapper is invoked for that work_id
    Then the pair does not half-complete: the corresponding bead remains OPEN and is not closed
    And no closed-without-consume drift results — the wrapper's fail-safe ordering leaves the bead open precisely because the consume did not succeed, rolling back any partial close rather than leaving a closed bead alongside an unconsumed row

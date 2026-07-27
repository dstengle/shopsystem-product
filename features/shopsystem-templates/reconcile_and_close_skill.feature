Feature: shop-templates pours a reconcile-and-close skill that atomically consumes a BC work_done and closes its bead

  Directive (product authority, lead-t96cf): shop-templates pours a
  reconcile-and-close skill — like the write-<kind> writing skills — that
  performs "shop-msg consume" (of a BC work_done outbox row) AND "bd close" (of
  the corresponding bead) as ONE atomic reconcile-and-close action, so a
  consumed work_done can never be left with an open bead (the consume-not-equal-
  close drift). Scope is JUST the consume+close wrapping: the materialized
  bead->commit edge and the drift-audit are a separate follow-on and are NOT
  pinned here.

  Scenario: bootstrapping a lead shop pours the reconcile-and-close skill as a lead skill-group member
    Given an existing git repository at a target directory "/tmp/example-lead-shop" with no ".claude/skills/" directory
    When I invoke the "shop-templates" bootstrap entry point with shop type "lead", shop name "shopsystem-product", and target directory "/tmp/example-lead-shop"
    Then the exit code is 0
    And the target directory contains a file at ".claude/skills/reconcile-and-close/SKILL.md"
    And the content of ".claude/skills/reconcile-and-close/SKILL.md" names performing "shop-msg consume" of a BC "work_done" outbox row and "bd close" of the corresponding bead as one atomic reconcile-and-close action

  Scenario: invoking reconcile-and-close consumes the work_done outbox row and closes the corresponding bead together
    Given a consumable BC "work_done" outbox row for a work_id and a corresponding OPEN bead for that same work_id
    When the reconcile-and-close action is invoked for that work_id
    Then the "work_done" outbox row is consumed and no longer appears in "shop-msg pending outbox"
    And the corresponding bead for that work_id is closed

  Scenario: reconcile-and-close does not half-complete when the bd close fails — the work_done outbox row is left unconsumed
    Given a consumable BC "work_done" outbox row for a work_id and a corresponding bead whose "bd close" will fail
    When the reconcile-and-close action is invoked for that work_id
    Then the pair does not half-complete: the "work_done" outbox row remains unconsumed and still appears in "shop-msg pending outbox"
    And no consumed-but-open drift results — the outbox row stays present precisely because the close did not happen

  Scenario: reconcile-and-close does not half-complete when the work_done consume fails — the corresponding bead is left OPEN
    Given a work_id whose corresponding bead is OPEN and whose BC "work_done" outbox row cannot be consumed, so the "shop-msg consume" step fails
    When the reconcile-and-close action is invoked for that work_id
    Then the pair does not half-complete: the corresponding bead remains OPEN and is not closed
    And no closed-without-consume drift results — the bead stays open precisely because the consume did not happen

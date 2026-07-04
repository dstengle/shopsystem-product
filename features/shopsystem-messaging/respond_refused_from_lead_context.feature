@bc:shopsystem-messaging @origin:adr-018
Feature: shop-msg respond is refused from a lead-shop context (lead-mcps / lead-rl0f)

  Worldview A (ADR-018; 05-inter-shop-protocol.md §5.3): `shop-msg respond`
  is a BC->lead vehicle ONLY. There is no lead->BC `respond` row. When the
  CALLER's shop (resolved by CWD walk-up to the nearest .claude/shop/type.md)
  is a lead, EVERY respond sub-verb — clarify, work_done,
  mechanism_observation — is refused with a non-zero exit and a stderr
  message directing the lead to the lead->BC vehicles (send / nudge /
  consume). This pins the rl0f direction-guard (red-before-green).

  @scenario_hash:9a78a03181847c80
  Scenario: shop-msg respond clarify is refused from a lead-shop CWD context
    Given a lead-shop CWD context registered as "shopsystem-product"
    When shop-msg respond clarify is run from the lead-shop CWD context
    Then the command exits non-zero
    And stderr states that "shop-msg respond" is a BC->lead vehicle only
    And stderr directs the caller to shop-msg send, shop-msg nudge, and shop-msg consume

  @scenario_hash:fab4c5c16e7ca234
  Scenario: shop-msg respond work_done is refused from a lead-shop CWD context
    Given a lead-shop CWD context registered as "shopsystem-product"
    When shop-msg respond work_done is run from the lead-shop CWD context
    Then the command exits non-zero
    And stderr states that "shop-msg respond" is a BC->lead vehicle only
    And stderr directs the caller to shop-msg send, shop-msg nudge, and shop-msg consume

  @scenario_hash:331378a4b6751818
  Scenario: shop-msg respond mechanism_observation is refused from a lead-shop CWD context
    Given a lead-shop CWD context registered as "shopsystem-product"
    When shop-msg respond mechanism_observation is run from the lead-shop CWD context
    Then the command exits non-zero
    And stderr states that "shop-msg respond" is a BC->lead vehicle only
    And stderr directs the caller to shop-msg send, shop-msg nudge, and shop-msg consume

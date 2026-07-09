@bc_internal
Feature: lead-po template — commitment-owner identity after PDR-033 re-homing

  # PDR-033 (P02) re-homes the upstream interactive disciplines
  # (interview/discovery, shaping, option facilitation) from the lead-po
  # charter to the new lead-pm main-session mode. The lead-po now RECEIVES a
  # shaped candidate and owns the COMMITMENT (brief -> scenarios -> clarify
  # responses), not discovery. This scenario pins that reframed identity and
  # the batchable half of PDR-012's elevation the PO retains (amendment-a).

  @scenario_hash:8417a90ab75a9c4f @bc:shopsystem-templates
  Scenario: lead-po template names the commitment-owner identity and the durable disciplines it retains after PDR-033 re-homing
    Given PDR-033 re-homes problem discovery, shaping, and option facilitation from the lead-po to the lead-pm main-session mode
    When I read the lead-po template via "shop-templates show lead-po"
    Then the content names a commitment-owner identity that owns the outcome the commitment enables and receives a shaped candidate as its input, distinct from an order-taker who transcribes a pre-formed request into scenarios
    And the content states that the lead-po does not originate product direction — problem discovery, shaping, and option facilitation are conducted in the lead-pm main-session mode and the lead-po consumes their shaped candidate
    And the content states that this identity sharpens, and does not replace, the existing COMMIT TO SPECIFICS posture
    And the content names the durable disciplines the lead-po retains — outcome ownership within the commitment, strategy before backlog, and specification as the contract — each with at minimum one sentence of guidance OR an explicit "guidance pending" marker (case-insensitive)
    And no retained discipline appears as a bare list item with neither guidance nor a "guidance pending" marker

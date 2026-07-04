@bc_internal
Feature: lead-architect template grounds empirical pre-state verification in the contract/artifact surface (ADR-018 D1/D2)

    @scenario_hash:5f33bdf215b05d00 @bc:shopsystem-templates
    Scenario: lead-architect template requires empirical pre-state verification grounded in the contract/artifact surface, not BC-code reads or runs (ADR-018 D1/D2 pin)
    When I read the lead-architect template via "shop-templates show lead-architect"
    Then the content names "empirical" pre-state verification as the discipline for choosing between assign_scenarios, request_bugfix, and request_maintenance
    And the content names the contract/artifact surface — the lead's own "features/" Gherkin, "adr/"/"pdr/", message schemas, scenario hashes, and "shop-msg" mailbox state, together with the BC's reported "work_done" demonstration — as the admissible evidence for that choice
    And the content names invoking an installed contract tool such as "scenarios hash" over contract text as the admissible "run" that produces a contract fact
    And the content directs the architect that establishing a BC's behavior by reading or executing that BC's implementation is not admissible evidence, and that there is no "repos/" BC source on the lead host to read or run
    And the content directs the architect to route any question that would otherwise require running BC implementation to the BC as a "clarify" or "nudge", rather than reaching for the proof itself

    @scenario_hash:49ab4f75cacbe5aa @bc:shopsystem-templates
    Scenario: lead-architect template's pre-state discipline directs the architect to enumerate the conflicting BC @scenario_hash set from the lead-held features/ surface and the mailbox-reported register whenever a dispatch retires, supersedes, or contradicts prior BC-side coverage
    When I read the lead-architect template via "shop-templates show lead-architect"
    Then the content names "@scenario_hash" as a pre-state surface the architect must enumerate before composing a dispatch that retires, supersedes, or contradicts prior BC-side coverage
    And the content directs the architect to establish that @scenario_hash set from the lead-held "features/" Gherkin in this repo together with the BC's mailbox-reported scenario register/hashes, and not from a "repos/<bc>" clone
    And the content names invoking the installed "scenarios hash" contract tool over the lead-held scenario text as the means of computing the hashes for that enumeration
    And the content marks the enumeration as a discrete pre-state step (alongside the contract-surface behavior-verification step), not as optional guidance the architect may skip
    And the content names at least one of the trigger conditions "retire", "supersede", or "contradict" as the gate that requires the enumeration step

    @scenario_hash:eff845ff35a32a14 @bc:shopsystem-templates
    Scenario: lead-architect template names a concrete enumeration mechanism for the BC @scenario_hash pre-state surface that runs over the lead-held features/ Gherkin and the mailbox-reported register, with no clone grep
    When I read the lead-architect template via "shop-templates show lead-architect"
    Then the content names the literal substring "@scenario_hash" as the pattern the architect enumerates
    And the content names a concrete, mechanically observable enumeration mechanism that runs over the lead-held "features/" Gherkin in this repo, naming the installed "scenarios hash" contract tool as the means of computing each entry's hash
    And the content names the BC's mailbox-reported scenario register/hashes (carried in its "work_done" demonstration) as the second surface the architect reconciles that enumeration against
    And the content names the lead-held "features/" surface and the mailbox-reported register as the authoritative source for the BC's pinned @scenario_hash set, in contrast to a "repos/<bc>" clone grep
    And the content directs the architect not to run the enumeration against a "repos/<bc>/features/*.feature" tree, there being no such clone on the lead host

    @scenario_hash:977ef0c64307ff90 @bc:shopsystem-templates
    Scenario: lead-architect template directs the architect to re-run the BC @scenario_hash enumeration on every dispatch in a clarify-correction chain, against the full lead-held features/ surface and mailbox-reported register, not only the hashes a prior clarify named
    When I read the lead-architect template via "shop-templates show lead-architect"
    Then the content names a clarify-driven correction (a follow-up dispatch that augments or amends a prior dispatch in response to an Implementer clarify) as a moment that itself requires the BC @scenario_hash pre-state enumeration
    And the content directs the architect not to limit the re-enumeration to only the @scenario_hash entries a prior clarify named, but to re-run the full enumeration over the lead-held "features/" Gherkin in this repo reconciled against the BC's mailbox-reported scenario register/hashes
    And the content frames a prior clarify as evidence that the prior enumeration was incomplete, rather than as a definitive list of every conflicting BC-side @scenario_hash
    And the content names this per-event discipline as applying independently to each dispatch in a clarify-correction chain, not only to the initial dispatch in such a chain
    And the content directs the architect not to source the re-enumeration from a "repos/<bc>" clone tree, there being no such clone on the lead host

    @scenario_hash:022294afc87e1471 @bc:shopsystem-templates
    Scenario: lead-architect template requires the dispatch text to reference each conflicting @scenario_hash entry (established from the lead-held features/ surface and mailbox-reported register) by its hash ID or carry an explicit retirement instruction, cited in the same shape as the contract-surface verification step
    When I read the lead-architect template via "shop-templates show lead-architect"
    Then the content directs the architect that, for any dispatch that retires, supersedes, or contradicts prior BC-side coverage, the dispatch text must reference each conflicting @scenario_hash entry — as established from the lead-held "features/" surface and the BC's mailbox-reported register — by its hash ID, or carry an explicit retirement instruction for that hash
    And the content frames that requirement as the observable evidence the BC Implementer can use to confirm the architect ran the enumeration step, rather than as optional context for the BC
    And the content directs the architect to cite the enumeration in the dispatch description in the same shape that the contract-surface verification step (ADR-018 D1) is cited, so the Implementer does not have to re-derive the conflicts the architect missed

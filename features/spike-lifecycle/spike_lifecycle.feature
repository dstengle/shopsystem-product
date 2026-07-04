@bc:shopsystem-product @origin:pdr-016
Feature: spike lifecycle discipline

  @scenario_hash:62dc784fec917ca0
    Scenario: a spike whose intent lacks a falsifiable kill-or-confirm hypothesis is sent back before execution
      Given a spike bead filed under an initiative in the lead registry
      And the bead states only an open-ended "evaluate X" goal with no falsifiable hypothesis and no settling assertion
      When the spike is taken up for execution
      Then the spike is sent back to the intent stage before any scratch infra is stood up
      And the bead is required to state a kill-or-confirm hypothesis scoped to one substrate or seam, with at least one assertion that would settle it

  @scenario_hash:90624ab5718b9efc
    Scenario: a running spike uses spike-prefixed scratch with dummy data and commits nothing to lead or BC source
      Given a spike in throwaway execution that has stood up real infra to exercise its assertions
      When the spike's scratch infra is inspected during execution
      Then every container the spike stood up is named with a "spike-" prefix on the real network
      And the spike's infra holds only dummy or placeholder data, with the live fleet and real credentials untouched
      And nothing from the spike's scratch is committed to lead or BC source

  @scenario_hash:051d645744000a85
    Scenario: after a spike reaches a verdict, all scratch is torn down and only the findings document remains
      Given a spike that has reached a verdict after exercising its assertions
      When the spike completes and teardown runs
      Then no "spike-"-prefixed container, volume, or worktree branch from the spike remains on the lead host
      And the findings document for the spike survives as a durable artifact, together with its ADR only if the spike graduated
      And no throwaway scratch from the spike has leaked into lead or BC source

  @scenario_hash:44ce15274b53c9de
    Scenario: a completed spike records exactly one verdict drawn from the four-value vocabulary
      Given a spike that has exercised its planned assertions and produced a findings document
      When the spike's verdict is recorded
      Then the findings document records exactly one verdict whose value is one of confirm, go-with-caveats, no-go, or not-viable
      And a value outside that closed set, or an absent verdict, is rejected as not admissible
      And the findings document carries the verdict alongside its required sections, including "what Phase 2 must cover"

  @scenario_hash:3a14be3659e2516a
    Scenario: a spike hitting a human-gated step proves the plumbing creds-free, records the wall, and may still confirm
      Given a spike whose execution reaches a step requiring a one-time human secret the autonomous agent cannot supply
      When the spike handles that step
      Then the spike substitutes a dummy placeholder and does not fake the real secret
      And the spike proves everything up to the wall creds-free, producing a real artifact plus an expected failure a real secret would turn into success
      And the spike records the wall explicitly in its findings document as the one hard human-gated step, naming what the human must do and what resumes afterward
      And the spike may reach a confirm verdict with that wall carried forward as a Phase-2 operational step rather than treated as a verdict blocker

  @scenario_hash:b30a8b5ca2e066a0
    Scenario: a spike with a confirm verdict and implementation-requirements is graduated through the PDR-014 path on a fresh bead
      Given a spike that reached a confirm or go-with-caveats verdict and recorded implementation-requirements in its findings document
      When the finding is graduated
      Then lead-po authors the Phase-2 scenarios from the finding's implementation-requirements
      And lead-architect drafts the ADR and picks the discriminator vehicle for the kept Phase-2 work
      And the kept Phase-2 work is filed against a fresh lead bead distinct from the spike bead, whose work_id is not reused

  @scenario_hash:765f5473b2d121ec
    Scenario: a spike executes via Workflow and returns a markdown finding rather than a large array-heavy structured emit
      Given a spike that runs its execution through the Workflow multi-agent engine
      When the spike emits its durable finding
      Then the finding is returned as a markdown findings document of prose and small tables
      And the spike does not emit a large array-heavy StructuredOutput as its durable finding
      And any structured emit the spike does use is small and flat with no big arrays

  @scenario_hash:e6f84dc40468cc03
    Scenario: a spike that surfaces an unanticipated hazard records it in the finding and files a fresh bead for it
      Given a spike whose execution uncovers a hazard that was not part of its original hypothesis
      When the spike records its verdict and findings beyond the plan
      Then the new hazard is recorded in the spike's findings document as a finding beyond the plan
      And the new hazard is filed as a fresh lead bead distinct from the spike bead and from any graduation bead

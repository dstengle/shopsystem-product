@bc:shopsystem-bc-launcher @origin:lead-r34c
Feature: BC-standup resolves the derived owner into the in-container bd dolt remote so bd bootstrap does not clone ORIGIN_OWNER (GAP B, lead-r34c)

  Standing up shopsystem-knowledge via create-bc under fabro (David 2026-07-07):
  in-container "bd bootstrap" FAILED with "dolt clone
  git+https://github.com/ORIGIN_OWNER/shopsystem-knowledge-beads.git ...
  Repository not found". The scaffold was pushed with the "ORIGIN_OWNER"
  placeholder (correct at scaffold time — no origin owner yet), and the standup
  RESOLVED the owner to "dstengle" for the gh-create step (it printed
  dstengle/shopsystem-knowledge-beads), but it did NOT write the resolved owner
  back into the in-container ".beads" config / bd dolt remote — so "bd bootstrap"
  cloned the stale ORIGIN_OWNER URL and failed. The create-bc path runs no
  footing reconcile step (footing_host_port_and_beads_sync
  scenario_hash c1b769fb49c6ebfb is the LEAD-only fill), so the placeholder
  survives to launch.

  This pins the RUNTIME writeback outcome, distinct from the scaffold-text pins
  that already pass yet did not prevent the failure: bootstrap_bc_beads_remote_owner_substitution
  scenario_hash ef4f4d86d3e4d153 (config.yaml sync.remote text) and
  bootstrap_bc_functional_bd_dolt_remote @scenario_hash:8db8399c92702704
  (functional remote at bootstrap time). Here the bar is that by the time the
  in-container "bd bootstrap" runs, NO literal ORIGIN_OWNER survives in the
  functional bd dolt remote. Fidelity binds to the executable standup
  provisioning surface plus the in-container config observed via "bd dolt remote
  list" / the "bd bootstrap" clone target, NOT a live GitHub clone.

  DECOMPOSITION CALL (for the Architect): the missing writeback is in-container,
  after scaffold — FIX (a) the bc-launcher standup resolves ORIGIN_OWNER -> derived
  owner in the in-container .beads config + bd dolt remote BEFORE bd bootstrap; or
  FIX (b) shop-templates/footing substitutes the owner in the pushed repo. The
  scaffold-side pins already pass yet the placeholder still reached launch, which
  points at (a) shopsystem-bc-launcher standup. Left @bc-less for the Architect
  to finalize.

  @scenario_hash:8ca9508bd7f5fecf
  Scenario: after standup the new BC's functional bd dolt remote resolves to the derived owner so bd bootstrap clones <owner>/<bc>-beads instead of the ORIGIN_OWNER placeholder
    Given a new BC whose shop-name slug is "<bc>" is stood up from a lead whose GitHub owner resolves to "<owner>"
    And its scaffolded beads tracker config was pushed carrying the literal "ORIGIN_OWNER" placeholder in the tracker remote because no origin owner was known at scaffold time
    When the BC-standup flow provisions the in-container beads tracker and runs "bd bootstrap"
    Then the in-container tracker's functional bd dolt remote, the one "bd dolt remote list" reports and "bd bootstrap" clones from, contains no literal "ORIGIN_OWNER" segment
    And that functional bd dolt remote's owner segment equals the derived GitHub owner "<owner>" so its clone target is "<owner>/<bc>-beads"
    And "bd bootstrap" for the new BC exits zero instead of failing "Repository not found" against an "ORIGIN_OWNER/<bc>-beads" URL

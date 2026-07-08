@bc:shopsystem-bc-launcher @origin:adr-057
Feature: bc-container launch pours /workspace/.fabro/ after clone and retires the baked fabro-def bundle (lead-xinb)

  ADR-057 moves the fabro def's DELIVERY from baked to poured. bc-container
  launch runs the shop-templates pour that emits "/workspace/.fabro/" INSIDE
  the container workspace after clone — PARALLEL to the existing ".claude/skills/"
  pour (@scenario_hash:75ae95be0ecf1640), out of the same baked shop-templates
  binary. A "--workspace-mount" launch SKIPS the pour and uses the committed
  "/workspace/.fabro/" byte-unchanged, exactly as the committed ".claude/skills/"
  tree is treated today. The baked fabro-def bundle at
  "src/bc_launcher/assets/fabro-def/" is RETIRED — the def is no longer baked
  into bc-base. This is the launch-emit / retirement half; the def's VALIDITY
  re-homes to shopsystem-templates (@scenario_hash:d08bac49e20111f2), and the
  runtime fabro binary + oauth-shim stay BAKED (ADR-057 D5, unchanged).

  FIDELITY (test-fidelity-for-image-layer-container-runtime-scenarios): the step
  defs drive the REAL launcher (controller.launch over the DockerDriver seam)
  and bind to its ACTUAL recorded launch steps — the pour that emits
  "/workspace/.fabro/" after clone, the "--workspace-mount" pour-skip using the
  committed tree, and the ABSENCE of the retired baked bundle on the image —
  never to a model.

  @scenario_hash:61250fcb8dcbd846
  Scenario: bc-container launch runs the shop-templates pour that emits "/workspace/.fabro/" after clone, "--workspace-mount" skips the pour and uses the committed def byte-unchanged, and the baked fabro-def bundle is retired
    Given the shopsystem-bc-launcher BC is installed
    And a BC named "shopsystem-messaging" with a valid repo URL is configured
    And the bc-base image carries the shop-templates binary
    When I run bc-container launch with BC name "shopsystem-messaging"
    And the container has cloned the repository
    Then the shop-templates pour has been run inside the container's workspace directory and has emitted "/workspace/.fabro/" after clone, parallel to the ".claude/skills/" pour (scenario @scenario_hash:75ae95be0ecf1640)
    And when bc-container launch is run with "--workspace-mount" the pour is SKIPPED and the committed "/workspace/.fabro/" is used byte-unchanged, exactly as the committed ".claude/skills/" tree is treated
    And the baked fabro-def bundle at "src/bc_launcher/assets/fabro-def/" is absent from the image, the fabro def no longer being baked into bc-base but poured at launch, so the RETIRED bundle is no longer a delivery surface

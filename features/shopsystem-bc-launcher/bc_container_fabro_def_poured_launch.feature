@bc:shopsystem-bc-launcher @origin:adr-057
Feature: bc-container launch pours /workspace/.fabro/ after clone and retires the baked fabro-def bundle (lead-xinb)

  ADR-057 moves the fabro def's DELIVERY from baked to poured. bc-container
  launch runs the shop-templates pour that emits "/workspace/.fabro/" INSIDE
  the container workspace after clone — PARALLEL to the existing ".claude/skills/"
  pour (@scenario_hash:75ae95be0ecf1640), out of the same baked shop-templates
  binary. A "--workspace-mount" launch SKIPS the pour and uses the committed
  "/workspace/.fabro/" byte-unchanged, exactly as the committed ".claude/skills/"
  tree is treated today. The fabro-def bundle formerly baked from
  "src/bc_launcher/assets/fabro-def/" is UNBAKED — absent from the packaged
  wheel (pyproject package-data) and the bc-base image (docker/bc-base/Dockerfile),
  so it is no longer a baked delivery surface; the repo source mirror REMAINS as
  the def source (it is NOT deleted), and the def is now delivered by the
  shop-templates pour at launch. This is the launch-emit / unbake half; the def's VALIDITY
  re-homes to shopsystem-templates (@scenario_hash:d08bac49e20111f2), and the
  runtime fabro binary + oauth-shim stay BAKED (ADR-057 D5, unchanged).

  FIDELITY (test-fidelity-for-image-layer-container-runtime-scenarios): the step
  defs drive the REAL launcher (controller.launch over the DockerDriver seam)
  and bind to its ACTUAL recorded launch steps — the pour that emits
  "/workspace/.fabro/" after clone, the "--workspace-mount" pour-skip using the
  committed tree, and the ABSENCE of the unbaked fabro-def bundle from the
  packaged wheel and the bc-base image (the repo source mirror remaining) —
  never to a model.

  @scenario_hash:7700eea079ffe1d8
  Scenario: bc-container launch runs the shop-templates pour that emits "/workspace/.fabro/" after clone, "--workspace-mount" skips the pour and uses the committed def byte-unchanged, and the baked fabro-def bundle is retired
    Given the shopsystem-bc-launcher BC is installed
    And a BC named "shopsystem-messaging" with a valid repo URL is configured
    And the bc-base image carries the shop-templates binary
    When I run bc-container launch with BC name "shopsystem-messaging"
    And the container has cloned the repository
    Then the shop-templates pour has been run inside the container's workspace directory and has emitted "/workspace/.fabro/" after clone, parallel to the ".claude/skills/" pour (scenario @scenario_hash:75ae95be0ecf1640)
    And when bc-container launch is run with "--workspace-mount" the pour is SKIPPED and the committed "/workspace/.fabro/" is used byte-unchanged, exactly as the committed ".claude/skills/" tree is treated
    And the fabro-def bundle formerly baked from "src/bc_launcher/assets/fabro-def/" is absent from the packaged wheel (pyproject package-data) and the bc-base image (docker/bc-base/Dockerfile) — no longer a baked delivery surface — while the shop-templates pour delivers "/workspace/.fabro/" at launch, the repo source mirror remaining as the def source

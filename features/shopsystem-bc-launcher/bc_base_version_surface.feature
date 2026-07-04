@bc:shopsystem-bc-launcher @origin:lead-5xnd
Feature: published bc-base / bc-lead images surface the bc-launcher release and baked shop-templates versions via OCI labels and ENV (lead-5xnd)

  The published shopsystem-bc-base and shopsystem-bc-lead images are built FROM
  the upstream mcr.microsoft.com/devcontainers/python base, which carries a
  misleading OCI label org.opencontainers.image.version == "3.1.2".  The
  bc-launcher publish must OVERRIDE that inherited value so the published images
  surface the bc-launcher release version (the pushed v* tag) and the baked
  shop-templates version, both as OCI labels and as container ENV.

  Per the architect ruling on the bc-base image-publishing scenarios (live
  registry / live Actions / docker inspect state is OUT-OF-BAND, scenario-40
  declarative-shape precedent), and because docker is NOT available in this
  test environment, these scenarios are pinned at the honest fidelity level for
  DECLARATIVE labels/ENV: the committed publish-bc-base.yml `labels:` inputs and
  the committed Dockerfile ENV instructions are asserted by parsing the real
  workflow YAML and Dockerfile text.  The live `docker image inspect` /
  `docker container inspect` of the published image is the lead's post-release
  pull verification, out of band of this suite.

  @scenario_hash:7c0c949fccdf9df2
  Scenario Outline: a published bc-launcher image surfaces its bc-launcher release version and baked shop-templates version via OCI labels and ENV, overriding the misleading upstream base version label
    Given the bc-launcher publish workflow built and published the "<image>" image at bc-launcher release version "v0.3.38" baking shop-templates version "v0.47.0"
    When the published "<image>:latest" image is examined with "docker image inspect"
    Then the image's "org.opencontainers.image.version" OCI label equals the bc-launcher release version "v0.3.38"
    And the image's "org.opencontainers.image.revision" OCI label is a non-empty git commit sha identifying the source revision the image was built from
    And the image's "shopsystem.shop-templates.version" OCI label equals the baked shop-templates version "v0.47.0"
    And the image's configured environment includes "SHOPSYSTEM_BC_LAUNCHER_VERSION" equal to the bc-launcher release version "v0.3.38"
    And the image's configured environment includes "SHOP_TEMPLATES_VERSION" equal to the baked shop-templates version "v0.47.0"
    And the bc-launcher version surfaced by inspect is "v0.3.38" rather than the upstream devcontainer base label value "3.1.2"

    Examples:
      | image                               |
      | ghcr.io/dstengle/shopsystem-bc-base |
      | ghcr.io/dstengle/shopsystem-bc-lead |

  @scenario_hash:26d1817c9d115f0d
  Scenario: a container started from bc-base:latest surfaces the baked bc-launcher and shop-templates versions via container inspect, independent of the lost run-tag
    Given the published "ghcr.io/dstengle/shopsystem-bc-base" image at bc-launcher release version "v0.3.38" baking shop-templates version "v0.47.0" carries those versions as OCI labels and ENV
    And a container is started from that image addressed only by its "latest" tag, so the originating version tag is not recoverable from the running container
    When the running container is examined with "docker container inspect"
    Then the container's configured labels surface "org.opencontainers.image.version" equal to the bc-launcher release version "v0.3.38"
    And the container's configured labels surface "shopsystem.shop-templates.version" equal to the baked shop-templates version "v0.47.0"
    And the container's configured environment surfaces "SHOPSYSTEM_BC_LAUNCHER_VERSION" equal to "v0.3.38"
    And the container's configured environment surfaces "SHOP_TEMPLATES_VERSION" equal to "v0.47.0"
    And the surfaced bc-launcher version is "v0.3.38" rather than the upstream devcontainer base label value "3.1.2"

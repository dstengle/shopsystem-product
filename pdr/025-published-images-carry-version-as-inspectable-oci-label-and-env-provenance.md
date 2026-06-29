# PDR-025 — Published bc-launcher images carry their bc-launcher version and baked shop-templates version as inspectable OCI-label + ENV provenance

**Status:** draft (2026-06-29)
**Authors:** dstengle (intent), Claude (lead-po)
**Lead bead:** [`lead-5xnd`](#) — *Bake version into published images as OCI labels + ENV (bc-base/bc-lead)* (feature, P1).
**Roadmap:** step 1 of the version-management roadmap; foundation for
[`lead-h2p0`](#) (step 2 — version-dependency surfacing) and the system BOM
(step 3).

**Anchored to** the product-authority statement (2026-06-29):

> get the bc-launcher (image) version + baked component versions INTO the
> published images so that `docker image inspect` / `docker container inspect`
> shows the version, not just `:latest` — "so that when you tell me about an
> image, I can be sure I'm using the right one."

That statement pins both scope and vocabulary for this PDR — no discovery
workshop was required.

## Point of intent

Today a published image's identity is not verifiable from the image or a
container started from it. `bc-base:latest` carries only the upstream
devcontainer base's `version=3.1.2` label — which is *misleading*, since it is
not the shopsystem/bc-launcher version — and there is no label or env naming
the bc-launcher release or the baked shop-templates version. The observable
behavior change: an operator (or an agent) runs one inspect/printenv against an
image or a running container and reads the correct bc-launcher and
shop-templates versions, instead of having no recoverable answer.

The JTBD: "when I am told about an image, confirm I am running the right one."
The value is verifiable provenance; the synergy is that it makes two already-
filed checks cheap — bootstrap baked-version verify (`lead-b2iz`) becomes a
docker-inspect / printenv read instead of a `pip show`, and `bin/doctor`
(`lead-q3r1`) can report the version from the same keys.

## The decision

**D1 — provenance is carried as OCI labels AND ENV, not as tags.** Tags cannot
carry it: `:latest` and `:vX.Y.Z` are the same digest, and the run-tag is not
recoverable from a pulled image or a running container. Labels and ENV are
baked at build time (the values already exist there) and inherit onto every
container regardless of run-tag.

**D2 — the contract is the inspect-surfaced key set, named explicitly:**

- OCI labels: `org.opencontainers.image.version` = the bc-launcher release
  version; `org.opencontainers.image.revision` = the source git sha;
  `shopsystem.shop-templates.version` = the baked shop-templates version.
- ENV: `SHOPSYSTEM_BC_LAUNCHER_VERSION` = the bc-launcher release version;
  `SHOP_TEMPLATES_VERSION` = the baked shop-templates version.

The key *names* are part of the contract — downstream consumers (b2iz, doctor)
read them by name. The keys are pinned; the Dockerfile mechanism that emits
them, and the publish-workflow build-arg wiring, are the BC's to author.

**D3 — the misleading upstream `version=3.1.2` is overridden/disambiguated.**
What `inspect` surfaces as the version must be the bc-launcher release version,
not the upstream base label value. This applies to BOTH published images,
bc-base and bc-lead.

**D4 — the contract is the observable, not the probe.** Scenarios pin what
`docker image inspect` and `docker container inspect` surface; they do not pin
LABEL/ENV instruction ordering or CI step shape. Both surfaces are pinned
because both are real read paths: the image artifact (image inspect) and the
running container where the run-tag is lost (container inspect from `:latest`).

## Why a PDR (why this would be re-asked)

- **Why labels+ENV and not just a version tag?** D1 — the run-tag is not
  recoverable; only baked metadata that inherits onto containers answers the
  question. Recorded so step 2/3 build on the metadata path, not on tags.
- **Which exact keys?** D2 — recorded so b2iz and doctor read stable names and
  step 2's dependency map extends the same label namespace
  (`shopsystem.*.version`) rather than inventing a parallel one.
- **Is the misleading 3.1.2 in scope to fix?** D3 — yes; this is arguably
  part-bug, and disambiguating it is a named assertion, not a side effect.

## Decomposition / dispatch (architect, later — NOT done here)

- `lead-5xnd` → message-type discriminator: bc-launcher already publishes both
  images but emits no shopsystem provenance, so this adds a new capability to
  the publish path — author leans **`assign_scenarios`** to shopsystem-bc-launcher
  (scenarios 71, 72). The D3 override of the misleading `3.1.2` has a bug
  flavor; the architect confirms vehicle when verifying pre-state.

The architect verifies pre-state empirically against the contract/artifact
surface and adds the `@bc:` tag (and reconfirms the reproducing
`@scenario_hash`) at dispatch.

## Authored artifacts

- [`features/bc-launcher/71-published-image-carries-version-as-inspectable-oci-label-and-env.gherkin`](../features/bc-launcher/71-published-image-carries-version-as-inspectable-oci-label-and-env.gherkin)
  — `@scenario_hash:7c0c949fccdf9df2` (Scenario Outline over bc-base + bc-lead, image inspect).
- [`features/bc-launcher/72-container-from-latest-surfaces-baked-versions-independent-of-run-tag.gherkin`](../features/bc-launcher/72-container-from-latest-surfaces-baked-versions-independent-of-run-tag.gherkin)
  — `@scenario_hash:26d1817c9d115f0d` (container inspect from `:latest`, run-tag-independent).

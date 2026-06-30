# PDR-028 — bin/bootstrap verifies the pulled image's baked shop-templates version before rendering, and refuses a stale image

**Status:** draft (2026-06-30)
**Authors:** dstengle (intent), Claude (lead-po)
**Lead bead:** [`lead-b2iz`](#) — *bin/bootstrap does not verify the pulled image's baked shop-templates version — a stale/cached :latest silently renders an ancient shop* (bug, P1).
**Builds on:** [PDR-026](026-published-images-carry-version-as-inspectable-oci-label-and-env-provenance.md) (the provenance enabler, `lead-5xnd`), which explicitly named this bead as the consumer of the baked-version keys.

## Point of intent

A fresh adopter bootstrap of `testproduct3-lead` from the starter rendered an
ANCIENT shop (no `AGENT_VAULT_CA_PEM`, hardcoded product name, pre-`<changeme>`
style) instead of the current templates. Root cause (empirical, product
authority 2026-06-29): the rendered `bin/bootstrap` resolves the bc-lead/bc-base
image on a floating tag and `docker pull`s it, then **proceeds to render
regardless of what the pull actually fetched**. A stale/cached `:latest` (or a
silent pull/auth fallback to cache) makes the in-image `shop-templates bootstrap`
render an ancient shop, with no signal to the adopter.

The observable behavior change: bootstrap **reads** the pulled image's baked
shop-templates version and only renders when it meets an expected minimum;
on a stale image it **refuses loudly** instead of silently rendering. A cached
old `:latest` can no longer produce an ancient shop without the adopter knowing.

## The decision

**D1 — read the baked version from PDR-026 provenance, not from python.**
Bootstrap reads the baked shop-templates version from the image's PDR-026
provenance — the OCI label `shopsystem.shop-templates.version` (via
`docker image inspect`) or the ENV `SHOP_TEMPLATES_VERSION` (via `printenv` on
a container) — NOT via `pip show`/python in the image. PDR-026 shipped these
keys (verified live on bc-launcher v0.3.40 / templates 0.48.0) precisely so this
check is a cheap inspect/printenv read.

**D2 — refuse (fail non-zero), do not merely warn, on a stale image.** A
hard-warn that the human ignores reproduces the exact silent-render regression
this bug describes. The corrected behavior is to NOT render from a stale image
and to exit non-zero with a diagnostic naming the version it read, the expected
minimum it required, and an actionable remediation. (The bead allowed
"refuses OR hard-warns"; we commit to refuse because the failure being fixed is
precisely "proceeded anyway.")

**D3 — pin the mechanism, leave the floor's SOURCE to decomposition.** The
contract is: read baked version → compare to an expected-minimum known to
`bin/bootstrap` → gate. WHERE that floor value comes from (a re-rendered
constant, a pinned coordinate, the starter's own pinned version) is policy left
to the architect/BC, pinned here only as "expected-minimum known to
bin/bootstrap". This is the one thin spot — flagged, not silently inferred.

## Why a PDR (why this would be re-asked)

- **Refuse vs. hard-warn?** D2 — recorded so a future implementer does not
  "soften" the gate to a warning and silently re-open the regression.
- **Why not `pip show`?** D1 — recorded so the cheap label/ENV read path is the
  intended mechanism and the dependency on PDR-026 is explicit.
- **What is the expected minimum?** D3 — recorded as deliberately deferred
  policy, so the gap is a known open question, not an accidental omission.

## Decomposition / dispatch (architect, later — NOT done here)

- **Vehicle:** the capability (a rendered `bin/bootstrap` that pulls and renders)
  EXISTS but is unpinned/incorrect on the verify gate — author leans
  **`request_bugfix`** to the render owner (**shopsystem-templates**, the
  templates/ops bootstrap entry). Architect confirms vehicle on pre-state verify.
- **Delivery linkage:** the fix is a shop-templates template change, but adopters
  receive `bin/bootstrap` via the starter fork
  (`dstengle/shopsystem-starter`), which is STALE per **lead-x4mk** — reaching
  adopters ALSO requires the starter re-render. Architect should sequence
  lead-x4mk as the delivery leg.
- **Cross-refs:** **lead-ko2v** (bc-container launch uses cached `:latest` —
  same stale-`:latest` class, candidate sibling fix) and **lead-5xnd** /
  PDR-026 (the provenance enabler).

The architect verifies pre-state empirically against the contract/artifact
surface and adds the `@bc:` tag (and reconfirms the reproducing
`@scenario_hash`) at dispatch.

## Authored artifacts

- [`features/templates/226-bootstrap-verifies-pulled-image-baked-shop-templates-version-and-refuses-stale.gherkin`](../features/templates/226-bootstrap-verifies-pulled-image-baked-shop-templates-version-and-refuses-stale.gherkin)
  — `@scenario_hash:4457c8c280d4fbf4` (proceed when current) and
  `@scenario_hash:e9d64a8acc917efb` (refuse loudly when stale).

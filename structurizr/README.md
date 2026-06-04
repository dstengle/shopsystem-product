# structurizr workspace — canonical structural model

`workspace.dsl` is the **canonical §3.3 structural model** of the shopsystem
framework: the lead shop, every BC as a container, the shared postgres mailbox
and bd registry, the messaging hub's components, and dynamic views of the key
inter-shop interactions. It is the Architect's primary instrument for BC
decomposition and for reasoning about scenario-to-BC assignment "per
structurizr" (§3.2).

## What it contains

- **SystemContext** — the framework + operator + GitHub + GHCR.
- **Containers** — lead shop + 6 live BCs + 1 planned (ecommerce) + shared
  Postgres + bd registry; edges labelled `shop-msg over postgres`.
- **MessagingComponents** — the messaging hub internals (send/respond/consume,
  watch+heartbeat, catalog schemas, name registry, bd facade, postgres storage).
- **Dynamic views** — (a) `AssignScenariosFlow`, (b) `ClarifyRoundTrip`,
  (c) `BcBaseRebuild`.

## How to render

Interactive UI via the consolidated `structurizr/structurizr` image
(`local` mode serves http://localhost:8080):

```
docker run --rm -p 8080:8080 \
  -v "$(pwd)/structurizr:/usr/local/structurizr" \
  structurizr/structurizr local
```

Validate the DSL (CI-friendly; exits non-zero on any error):

```
docker run --rm -v "$(pwd)/structurizr:/work" -w /work \
  structurizr/structurizr validate -workspace workspace.dsl
```

Export diagrams (mermaid / plantuml / etc.):

```
docker run --rm -v "$(pwd)/structurizr:/work" \
  structurizr/structurizr export -workspace /work/workspace.dsl \
  -format mermaid -output /work/diagrams
```

> The legacy `structurizr/lite` and `structurizr/cli` images are deprecated and
> now print only a migration banner — use `structurizr/structurizr` above.
> (If running under docker-in-docker, bind mounts of in-container paths may not
> reach the daemon host; copy the DSL into a docker volume to validate.)

## Provenance (ADR-018 / PDR-011)

Built **only** from the contract/artifact surface — this repo's `01-`…`06-`
spec sections, `adr/`, `pdr/`, `features/`, message schemas, and the name
registry. **No BC implementation code was read** (the lead host carries none).
The DSL's header comment cites the surface source for every element and
relationship; keep it in sync with the ADRs as the model evolves.

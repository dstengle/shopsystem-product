# Getting started with shopsystem

You don't install a toolchain, edit YAML, or memorize commands. You start a
prebuilt image and **talk to the lead shop** — an AI agent — in plain language.
It does all the mechanical setup: your database, your credential **broker**, and
your **bounded-context (BC) shops** (the small services that do the work). You
step in only for the genuinely human parts: starting the image, saying what you
want, and approving your own credentials at the one gate that needs them.

> The substrate is proven end-to-end (broker, credential gate, BC launch, and the
> dispatch→build→reconcile loop — see [`findings/`](findings/)). Today the lead
> does the heavy lifting *with* you, narrating each step. If a step ever makes
> *you* learn the plumbing, that's a gap worth reporting.

## What you need

- **Docker**, with access to the Docker socket — the lead spins up sibling
  containers for you. Mac/Windows: Docker Desktop. Linux: your user must reach
  the socket (the `docker` group). Run the commands in a bash-compatible shell.
- **The prebuilt image** — CLIs, Claude, and the framework are baked in (nothing
  to `pip install`). It is public; no `docker login` needed:

  ```
  ghcr.io/dstengle/shopsystem-bc-lead:latest
  ```

- **Two of your own credentials**, supplied only when asked, never written to
  disk or mounted into a BC:
  - a **GitHub token** (<https://github.com/settings/tokens>) with `repo` and
    `workflow` scopes, plus your GitHub username; and
  - your **Claude credential** — the same account you use in the Claude app.

> **Side effects:** the lead creates GitHub repositories under your account (one
> per BC) and your BCs consume your Claude usage. The lead tells you what it
> creates as it goes.

## 1 — Start the lead

On your host, make a folder and run the image with the Docker socket mounted:

```bash
mkdir -p myproduct
docker run -it --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$PWD/myproduct:/work" -w /work \
  ghcr.io/dstengle/shopsystem-bc-lead:latest bash
```

The lead launches BCs, which needs the Docker CLI — so the lead runs on the
**bc-lead** image (bc-base has no Docker CLI and can't). Inside the container,
scaffold the folder into a lead shop and start the agent:

```bash
shop-templates bootstrap --shop-type lead --shop-name myproduct --target /work
claude
```

`claude` asks you to sign in to your Claude account (follow its link/prompt; on a
headless host it gives you a URL). This sign-in is for the **lead agent itself**.
Bootstrap laid down the lead's instructions, so the agent reads them and *becomes
the lead* for your product. It greets you and asks what to build. From here, you
talk to it.

> `myproduct` is your product's name (lowercase letters, digits, hyphens).

## 2 — Tell the lead what you want

Brief it like a colleague:

> *"Stand up this product. Add a BC called `greeter` that greets a person by
> name, build one small feature, and get it running."*

The lead drives it, narrating as it goes: brings up your database and broker,
provisions the broker (the one gate — see §3), creates and launches the
`greeter` BC, then authors a feature, dispatches it, and confirms the BC built
and passed it. You watch and answer when asked.

You'll know it worked when the lead reports the BC **online** and its test
**green**. Ask **"what's running?"** anytime, or **"how do I see it work?"** to
exercise the feature.

## 3 — The one gate that needs you: your credentials

Loading your secrets into the broker is the single thing the tooling can't do for
you. The lead runs the provisioning and needs from you:

1. a **broker owner password** you choose (the lead prompts for it);
2. your **GitHub token + username** (pasted when the lead provisions the broker);
3. your **Claude credential** — the lead stages a ready-to-approve **proposal**
   and hands you the one approve command to run, with the spot to paste your
   Claude token. You run it, tell the lead it's done, and provisioning finishes
   (the broker persists it as a refreshing OAuth credential and renews it
   automatically).

Everything else — vault names, scoping, credential formats, image tags — is the
lead's job. Afterward your credentials live only in the broker: **no real secret
ever enters a BC**; the broker swaps them in on outbound requests.

## 4 — Grow it — just ask

Your product is never "finished setup." Ask for more anytime:

> *"Create a BC called `billing` that issues invoices,"* or
> *"Add a feature to `greeter` that greets in a chosen language."*

For a new BC the lead handles the whole lifecycle — scaffold, repo, wiring,
launch — then dispatches the first work. For an existing BC it just dispatches.
Either way you describe the outcome; the lead does the container and wiring work.

## Shutting down

Your product runs as a few containers (database, broker, one per BC). To stop
them, ask the lead: **"stop everything for this product."** The `--rm` on
`docker run` only removes the lead's own shell — the services it spawned outlive
it until you stop them. Your files and GitHub repos remain.

## If something goes wrong

Ask the lead. It knows this system's sharp edges and either fixes them or tells
you exactly what it needs. You shouldn't have to learn the plumbing; if a step
asks *you* to know it, report it as a gap.

## Where the details live (for the curious)

- **The bootstrap narrative:** [`briefs/011-new-product-bootstrap-path.md`](briefs/011-new-product-bootstrap-path.md)
- **The broker model + the one human gate:** [ADR-026](adr/026-agent-vault-brokered-credentials-eliminate-host-filesystem-coupling.md)
- **Why the lead holds no BC source:** [ADR-018](adr/018-empirical-verification-is-contract-surface.md)

# Getting started with shopsystem

You don't install a toolchain, edit YAML, or learn any commands. You start a
prebuilt image, tell the **lead shop** — an AI agent — what you want to build,
and it stands your product up for you: its database, its credential broker, and
its **bounded-context (BC) shops** — the small services that do the actual work.
Need another capability later? Ask. The lead will **create a whole new BC** for
it and put it to work. You never touch a container command.

The only things that are yours to do: **start the image**, **say what you want**,
and **hand over two of your own credentials** at the one moment the lead asks.

---

## What you need

- **Docker**, with access to the Docker socket (the lead spins up sibling
  containers — your database, broker, and BCs — for you).
- **The prebuilt image** — everything (the CLIs, Claude, the framework) is baked
  in, so there is nothing to `pip install`:

  ```
  ghcr.io/dstengle/shopsystem-bc-base:latest
  ```

- **Two of your own credentials**, supplied only when the lead asks — never
  stored on disk, never mounted into a BC:
  - a **GitHub token** (so your BCs' code can be cloned/pushed), and
  - your **Claude credential** (so your BCs can think).

  A per-product **broker** holds these. Two products on one machine share
  nothing.

---

## 1 — Start the lead

Run the image and open a shell in it (mounting the Docker socket so the lead can
stand up your services):

```bash
docker run -it --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$PWD/myproduct:/work" -w /work \
  ghcr.io/dstengle/shopsystem-bc-base:latest bash
```

Inside, create your product's lead shop and start the agent:

```bash
shop-templates bootstrap --shop-type lead --shop-name myproduct   # one time
claude                                                            # start the lead
```

> `myproduct` is your product's name (lowercase letters, digits, hyphens). Swap
> in whatever you're building.

The agent reads its own instructions on start and becomes **the lead** for your
product. From here you talk to it in plain language.

---

## 2 — Tell the lead what you want

Say it the way you'd brief a colleague. For example:

> *"Stand up this product. Add a BC called `greeter` that greets a person by
> name, build one small feature for it, and get it running."*

The lead takes it from there — it will, on its own:

- bring up your product's **database** and **credential broker**;
- **provision** the broker (the one step where it needs your credentials — see §3);
- **create the `greeter` BC** — scaffold it, make its repo, wire it to the
  broker, and launch it;
- author a small feature, **dispatch** it to the BC, and confirm the BC built
  and passed it.

You watch it work. You don't run any of these steps yourself.

---

## 3 — The one human moment: hand over your credentials

Standing up the broker is the single point where the tooling genuinely needs
**you** — it cannot supply your real secrets. The lead will pause and ask for
exactly two things, in plain terms:

1. **Your GitHub token** — when the lead provisions the broker, it will ask you
   to paste your token (and your GitHub username). That's it.
2. **Your Claude credential** — the lead stages a ready-to-approve request for
   it, then tells you the **one command to run** to approve it, with your Claude
   token filled in where you paste your secret. Run that command, tell the lead
   it's done, and it finishes.

That's the whole human gate — paste a token, run one approve command the lead
hands you, done. Everything about *how* the broker is wired (vault names, scoping,
credential formats, the exact image tags) is the lead's job, not yours — if any
of it needs deciding, the lead decides it.

After this, your credentials live only in the broker. **No real secret ever
enters a BC** — the broker swaps them in on outbound requests and refreshes your
Claude credential automatically.

---

## 4 — Grow it — just ask

Your product is never "finished setup." When you want more, ask:

> *"Create a BC called `billing` that issues invoices,"* or
> *"Add a feature to `greeter` that greets in a chosen language."*

The lead **creates new BCs from scratch** — scaffolds them, makes their repos,
wires and launches them — and dispatches work to existing ones, all from your
plain-language request. You never learn or run container commands; that's the
lead's abstraction to manage.

You can also ask it to show you what's running (*"what BCs are up?"*), pause one,
or walk you through what it just did.

---

## If something goes wrong

Ask the lead. It knows this system's sharp edges — the credential-name format the
broker demands, the vault-scoping the approval needs, the right image tag to
launch a BC from — and it will diagnose and fix them, or tell you precisely what
it needs from you. You should not have to learn any of that yourself; if a step
ever asks *you* to know it, that's a gap worth reporting.

---

## Where the details live (for the curious)

You don't need these to get started — they're the authoritative specs behind what
the lead does for you:

- **The bootstrap narrative:** [`briefs/011-new-product-bootstrap-path.md`](briefs/011-new-product-bootstrap-path.md)
- **Why no real credential ever enters a BC (the broker model + the one human step):**
  [ADR-026](adr/026-agent-vault-brokered-credentials-eliminate-host-filesystem-coupling.md)
- **Why the lead never holds BC source; everything is brokered and
  contract-verified:** [ADR-018](adr/018-empirical-verification-is-contract-surface.md)
- **Proven end-to-end transcripts** (what the lead actually runs under the hood):
  [`findings/dummyco-spike-iter-5.md`](findings/dummyco-spike-iter-5.md) (provision
  → human gate) and [`findings/dummyco-spike-iter-7.md`](findings/dummyco-spike-iter-7.md)
  (BC creation → working feature).

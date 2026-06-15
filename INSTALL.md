# Getting started with shopsystem

You don't install a toolchain, edit YAML, or learn any commands. You start a
prebuilt image, tell the **lead shop** — an AI agent that runs the whole setup
for you — what you want to build, and it stands your product up: its database,
its credential **broker** (a small service that safely holds your secrets), and
its **bounded-context (BC) shops** — the small services that do the actual work.
Need another capability later? Ask. The lead will **create a whole new BC** for
it and put it to work. You never touch a container command.

The only things that are yours to do: **start the image**, **say what you want**,
and **hand over two of your own credentials** at the moments the lead asks.

> **Is this real, or aspirational?** Real. The lead doing all of this —
> provisioning the broker, creating a BC from scratch, building and passing a
> feature — is captured in actual end-to-end transcripts:
> [`findings/dummyco-spike-iter-5.md`](findings/dummyco-spike-iter-5.md) (setup →
> credential gate) and
> [`findings/dummyco-spike-iter-7.md`](findings/dummyco-spike-iter-7.md) (a BC
> created and serving a working feature). This guide is the front door to that
> flow.

---

## What you need

- **Docker**, with access to the Docker socket — the lead spins up sibling
  containers (your database, broker, and BCs) for you. On **Mac/Windows** use
  Docker Desktop; on **Linux** make sure your user can reach the socket (the
  `docker` group). No Docker yet? Install it first: <https://docs.docker.com/get-docker/>.
  Run the commands below in a **bash-compatible shell** (macOS Terminal, Linux
  shell, or Git Bash / WSL on Windows).
- **The prebuilt image** — everything (the CLIs, Claude, the framework) is baked
  in, so there is nothing to `pip install`. It is **public**; no `docker login`
  needed:

  ```
  ghcr.io/dstengle/shopsystem-bc-base:latest
  ```

- **Two of your own credentials**, supplied only when the lead asks — never
  stored on disk, never mounted into a BC:
  - a **GitHub token** — create one at <https://github.com/settings/tokens> with
    the **`repo`** and **`workflow`** scopes (your BCs' code is cloned/pushed and
    their release workflows are triggered under your account), and
  - your **Claude credential** — the login for the same Claude account you use in
    the Claude app / claude.ai. You'll sign in with it once when the agent
    starts (below), and the lead reuses that to let your BCs think.

  A per-product **broker** holds these. Two products on one machine share
  nothing.

> **Heads-up on side effects:** the lead creates **GitHub repositories under your
> account** for each BC, and your BCs use your Claude account to work — so this
> consumes Claude usage and adds repos to your GitHub. Nothing is hidden; the
> lead tells you what it's creating as it goes.

---

## 1 — Start the lead

Make a folder for your product, then run the image with the Docker socket mounted
so the lead can stand up your services:

```bash
mkdir -p myproduct
docker run -it --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$PWD/myproduct:/work" -w /work \
  ghcr.io/dstengle/shopsystem-bc-base:latest bash
```

Inside the container, run **one** command to create your product's lead shop,
then start the agent:

```bash
shop-templates bootstrap --shop-type lead --shop-name myproduct   # creates the lead shop
claude                                                            # start the agent (sign in when prompted)
```

> `myproduct` is your product's name (lowercase letters, digits, hyphens). Swap
> in whatever you're building. The `bootstrap` command lays down the lead shop so
> that, when `claude` starts in this folder, it reads its instructions and
> **becomes the lead** for your product. Signing in to `claude` uses the same
> Claude credential listed above — you do it once, and the lead handles making it
> available to your BCs later (§3).

The agent reads its own instructions on start and becomes **the lead** for your
product. From here you talk to it in plain language.

---

## 2 — Tell the lead what you want

Say it the way you'd brief a colleague. For example:

> *"Stand up this product. Add a BC called `greeter` that greets a person by
> name, build one small feature for it, and get it running."*

The lead takes it from there — it will, on its own:

- bring up your product's **database** and **credential broker**;
- **provision** the broker (load your credentials into it — the one step where it
  needs you; see §3);
- **create the `greeter` BC** — scaffold it, make its repo, wire it to the
  broker, and launch it;
- author a small feature, **dispatch** it to the BC (hand it the work), and
  confirm the BC built and passed it.

You watch it work. You don't run any of these steps yourself.

### What success looks like

You'll know it worked when the lead reports the `greeter` BC **online** and its
feature's test **passing** — e.g. *"greeter is up; the greet-by-name feature is
built and green."* At any time you can ask **"what's running?"** and the lead
will show you the live services and BCs. If you asked for a feature you can try,
ask the lead **"how do I see it work?"** and it will show you.

---

## 3 — The one human moment: hand over your credentials

Loading your secrets into the broker is the single point where the tooling
genuinely needs **you** — it cannot supply your real secrets. The lead pauses and
asks for exactly two things, in plain terms:

1. **Your GitHub token** — when the lead provisions the broker, it asks you to
   paste the token (and your GitHub username) you created above. That's it.
2. **Your Claude credential** — the lead stages a ready-to-approve request for it
   and tells you the **one command to run** to approve it, with the place to paste
   your Claude token. (It's the same account you signed into in §1; the lead may
   be able to reuse that sign-in so there's nothing to paste.) Run what it hands
   you, tell the lead it's done, and it finishes.

That's the whole human gate — paste a token, approve one request the lead hands
you, done. Everything about *how* the broker is wired (vault names, scoping,
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

## Shutting down

Your product runs as a set of containers (a database, a broker, and one per BC).
To stop them, just ask the lead: **"stop everything for this product."** It tears
down the containers it created. (The `--rm` on the `docker run` above only removes
the lead's own shell — the services it spawned outlive it until you stop them.)
Your product's files and its GitHub repos remain; nothing is lost by stopping.

---

## If something goes wrong

Ask the lead. It knows this system's sharp edges — the credential-name format the
broker demands, the vault-scoping the approval needs, the right image tag to
launch a BC from — and it will diagnose and fix them, or tell you precisely what
it needs from you. You should **not** have to learn any of that yourself; if a
step ever asks *you* to know it, that's a gap worth reporting.

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
  [`findings/dummyco-spike-iter-5.md`](findings/dummyco-spike-iter-5.md) and
  [`findings/dummyco-spike-iter-7.md`](findings/dummyco-spike-iter-7.md).

# Getting started with shopsystem

You don't install a toolchain, edit YAML, or memorize commands. You start a
prebuilt image, and from there you **work with the lead shop** — an AI agent —
in plain language. It runs the mechanical setup for you (your database, your
credential **broker**, your **bounded-context (BC) shops** — the small services
that do the actual work) and it scaffolds, wires, and launches BCs so you never
type a container command. You step in only for the parts that genuinely need
you: **starting the image**, **saying what you want**, and **handing over your
own credentials** at the one gate that needs them.

> **What's solid vs. still maturing.** The substrate is proven end-to-end: the
> broker, the credential gate, launching a BC, and the
> dispatch→build→reconcile loop all work (see the transcripts in
> [`findings/`](findings/dummyco-spike-iter-7.md)). The *fully hands-off* "one
> sentence and walk away" experience is what the lead is being built toward — so
> today the lead does the heavy lifting **with you**, narrating each step and
> pausing where it needs a decision or a secret. If a step ever makes *you* learn
> the plumbing, that's a gap worth reporting.

---

## What you need

- **Docker**, with access to the Docker socket — the lead spins up sibling
  containers (your database, broker, and BCs) for you. On **Mac/Windows** use
  Docker Desktop; on **Linux** make sure your user can reach the socket (the
  `docker` group). No Docker yet? <https://docs.docker.com/get-docker/>. Run the
  commands in a **bash-compatible shell** (macOS Terminal, Linux shell, or Git
  Bash / WSL on Windows).
- **The prebuilt image** — the CLIs, Claude, and the framework are baked in, so
  there is nothing to `pip install`. It is **public**; no `docker login` needed:

  ```
  ghcr.io/dstengle/shopsystem-bc-base:latest
  ```

- **Two of your own credentials**, supplied only when asked — never written to
  disk, never mounted into a BC:
  - a **GitHub token** — create one at <https://github.com/settings/tokens> with
    the **`repo`** and **`workflow`** scopes (your BCs' code is cloned/pushed and
    their workflows triggered under your account), and
  - your **Claude credential** — the same Claude account you use in the Claude
    app / claude.ai. You use it in two quick moments: signing the **lead agent**
    in when it starts (§1), and letting the lead load it into your **broker** so
    your BCs can think (§3). Have your **GitHub username** handy too — the broker
    wants it alongside the token.

  A per-product **broker** holds these. Two products on one machine share
  nothing.

> **Side effects, stated plainly:** the lead creates **GitHub repositories under
> your account** (one per BC) and your BCs use your Claude account to work — so
> this adds repos to your GitHub and consumes Claude usage. The lead tells you
> what it's creating as it goes.

---

## 1 — Start the lead

On your **host machine**, make a folder for your product and run the image with
the Docker socket mounted (this drops you into a shell *inside* the container):

```bash
mkdir -p myproduct
docker run -it --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$PWD/myproduct:/work" -w /work \
  ghcr.io/dstengle/shopsystem-bc-base:latest bash
```

Inside the container, scaffold this folder into a lead shop, then start the
agent:

```bash
shop-templates bootstrap --shop-type lead --shop-name myproduct   # turns /work into a lead shop
claude                                                            # start the agent
```

When `claude` starts it asks you to sign in to your Claude account (an
interactive sign-in — follow its link/prompt; on a headless host it gives you a
URL to open in your browser). This sign-in is for the **lead agent itself** —
it's how the lead is allowed to think. (Later, in §3, you separately let the lead
load your Claude credential into the **broker** so your *BCs* can think too —
same account, different job.)

Because `bootstrap` laid down the lead shop's instructions, the agent reads them
on start and **becomes the lead** for your product. You'll know it's ready when
it greets you and asks what you'd like to build. From here, you talk to it.

> `myproduct` is your product's name (lowercase letters, digits, hyphens).

---

## 2 — Tell the lead what you want

Brief it the way you'd brief a colleague:

> *"Stand up this product. Add a BC called `greeter` that greets a person by
> name, build one small feature for it, and get it running."*

The lead drives it from there, narrating as it goes. It will:

- bring up your product's **database** and **credential broker**;
- **provision** the broker — load your credentials into it (the one place it
  needs you; see §3);
- **create the `greeter` BC** — scaffold it, make its repo, wire it to the
  broker, and launch it;
- author a small feature, **dispatch** it to the BC, and confirm the BC built and
  passed it.

You don't run these steps yourself — you watch them happen and answer when the
lead asks.

### What success looks like

You'll know it worked when the lead reports the BC **online** and its feature's
test **passing** — e.g. *"greeter is up; greet-by-name is built and green."* Ask
**"what's running?"** anytime to see the live services and BCs, or **"how do I
see it work?"** to exercise the feature.

---

## 3 — The one gate that needs you: your credentials

Loading your real secrets into the broker is the single point the tooling can't
do for you. The lead walks you through it and needs:

1. **A broker owner password** — you choose it; it's how you (and the lead)
   administer this product's broker. The lead prompts for it.
2. **Your GitHub token + username** — pasted when the lead provisions the broker.
3. **Your Claude credential** (loaded into the broker for your BCs — this is the
   second of the two Claude moments from §1, *not* a repeat of the lead's own
   sign-in). The lead stages a ready-to-approve request for it and hands you the
   **one approve command to run**, with the spot to paste your Claude token. You
   run it, tell the lead it's done, and provisioning finishes.

That's the gate: a password you pick, a GitHub token, and approving one staged
request with your Claude token. Everything about *how* the broker is wired —
vault names, scoping, credential formats, image tags — is the lead's job; if any
of it needs deciding, the lead decides it and tells you what it did.

Afterward your credentials live only in the broker. **No real secret ever enters
a BC** — the broker swaps them in on outbound requests and refreshes your Claude
credential automatically.

---

## 4 — Grow it — just ask

Your product is never "finished setup." Ask for more whenever:

> *"Create a BC called `billing` that issues invoices,"* or
> *"Add a feature to `greeter` that greets in a chosen language."*

For a brand-new BC the lead handles the whole lifecycle for you — scaffold, repo,
wiring, launch — and then dispatches the first work to it. For an existing BC it
just dispatches the new work. Either way you describe the outcome; the lead does
the container and wiring work.

You can also ask **"what's running?"**, have it pause a BC, or have it walk you
through what it just did.

---

## Shutting down

Your product runs as a few containers (a database, a broker, one per BC). To stop
them, ask the lead: **"stop everything for this product."** The `--rm` on the
`docker run` only removes the lead's own shell — the services it spawned outlive
it until you stop them. Your files and GitHub repos remain; nothing is lost by
stopping.

---

## If something goes wrong

Ask the lead. It knows this system's sharp edges — the credential-name format the
broker demands, the vault scoping the approval needs, the right image tag to
launch a BC from — and it diagnoses and fixes them or tells you exactly what it
needs. You should not have to learn any of that; if a step asks *you* to know it,
report it as a gap.

---

## Where the details live (for the curious)

Not needed to get started — the authoritative specs behind what the lead does:

- **The bootstrap narrative (a living design doc):** [`briefs/011-new-product-bootstrap-path.md`](briefs/011-new-product-bootstrap-path.md)
- **The broker model + the one human step:** [ADR-026](adr/026-agent-vault-brokered-credentials-eliminate-host-filesystem-coupling.md)
- **Why the lead holds no BC source; everything is brokered + contract-verified:** [ADR-018](adr/018-empirical-verification-is-contract-surface.md)
- **Proven transcripts of the substrate** (broker provision → credential gate, and
  BC launch → dispatch → working feature): [`findings/dummyco-spike-iter-5.md`](findings/dummyco-spike-iter-5.md),
  [`findings/dummyco-spike-iter-7.md`](findings/dummyco-spike-iter-7.md).

# INSTALL — bring up a new shopsystem product

Replace `myproduct` with your product slug (lowercase, digits, hyphens).
Supply your own values for `<your-github-token>`, `<your-github-username>`,
`<your-claude-token>`, `<owner-password>`.

## 1 — Start the lead container

```bash
mkdir myproduct
docker run -it --rm \
  --group-add "$(stat -c '%g' /var/run/docker.sock)" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$PWD/myproduct:/work" -w /work \
  ghcr.io/dstengle/shopsystem-bc-lead:latest bash
```

> `--group-add` puts the in-container `vscode` user in the host docker-socket
> group so it can run `docker compose` / `bc-container` (§3, §5). If your host
> UID isn't 1000, also `chown 1000:1000 myproduct` so the container can write
> `/work`.

## 2 — Bootstrap the lead shop

```bash
shop-templates bootstrap --shop-type lead --shop-name myproduct-product --target /work
cp .env.example .env
# edit .env: set AGENT_VAULT_MASTER_PASSWORD (e.g. openssl rand -base64 32)
```

## 3 — Bring up infra

```bash
docker compose up -d postgres agent-vault
```

> The compose `myproduct` network is compose-managed (no `external: true`):
> `docker compose up` creates it. Do NOT pre-run `docker network create`.

## 4 — Provision credentials into the broker

```bash
export GITHUB_TOKEN=<your-github-token>
export GITHUB_USERNAME=<your-github-username>
export AGENT_VAULT_OWNER_PASSWORD=<owner-password>
bin/agent-vault-provision
```

This runs `auth register` (first registrant = owner) → `vault create` →
`vault credential set GITHUB_USERNAME=… GITHUB_TOKEN=…` →
`vault service add` (github + claude services) →
`agent create myproduct-fleet --token-only` (mints the `av_agt_…` fleet token)
→ `ca fetch` → writes `AGENT_VAULT_ADDR/TOKEN/VAULT/CA_PEM` into `.env`.
It then stages the Claude-OAuth proposal and STOPS for you to approve it.

Approve the Claude proposal — paste your real Claude token:

```bash
bin/agent-vault-approve-claude <your-claude-token>
```

> The script auto-resolves the pending proposal, mints the vault-scoped session
> the approve needs (a bare owner session is rejected with "Session requires
> vault scope"), and applies the token — which rides the in-container argv only,
> never written to disk.

Verify provisioning:

```bash
bin/agent-vault-check
docker exec -i myproduct-agent-vault agent-vault vault credential list --vault myproduct
# expect: GITHUB_USERNAME, GITHUB_TOKEN, CLAUDE_OAUTH
```

## 5 — Start the lead agent, launch a BC, verify

Infra + broker provisioning (steps 3–4) must complete BEFORE the agent does
real work: the lead/BC agents get Claude through the broker MITM proxy, so an
unprovisioned broker yields an engaged-but-broken agent.

Start the brokered lead session:

```bash
bin/shop-shell
```

Declare the BC in `bc-manifest.yaml` (`product: myproduct` plus one
`{name, remote, role}` entry), then launch it:

```bash
bc-container manifest validate --product-slug myproduct
bc-container launch myproduct-greeter \
  --image ghcr.io/dstengle/shopsystem-bc-base:latest \
  --network myproduct \
  --repo-url <your-bc-repo-url> \
  --shopmsg-dsn "postgresql://myproduct:${POSTGRES_PASSWORD:-myproduct}@myproduct-postgres:5432/myproduct" \
  --agent-vault-broker http://myproduct-agent-vault:14322 \
  --env-file .env
```

Verify the BC is online and reconcile the first feature:

```bash
bc-container status myproduct-greeter
shop-msg pending outbox --lead myproduct
```

## Where details live

- Bootstrap narrative: `briefs/011-new-product-bootstrap-path.md`
- Broker model + the one human gate: `adr/026-agent-vault-brokered-credentials-eliminate-host-filesystem-coupling.md`
- Provisioning CLI surface (agent-vault 0.32.0): ADR-026 D2 addendum
- Cold-run walkthrough + gap ledger: `findings/install-walkthrough-2026-06-15.md`
- Why the lead holds no BC source: `adr/018-empirical-verification-is-contract-surface.md`

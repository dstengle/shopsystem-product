#!/usr/bin/env python3
"""dispatch_acp_agent.py -- NON-LLM ACP script-agent for dispatcher.fabro's
`dispatch` node (ADR-058 Amendment 2, lead-3zzu).

fabro drives this node via backend="acp" + acp.command="python3
dispatch_acp_agent.py": fabro speaks the agent-client-protocol (crate v0.11.1)
JSON-RPC over stdio -- initialize -> session/new -> session/prompt. Fabro injects
NO model credentials into an ACP agent, and this agent runs NO model: it is a
pure python SCRIPT, so the dispatch step burns ZERO tokens.

CONTEXT-IN / DECISIONS-OUT. Each session/prompt delivers the poll context -- the
pending inbox work ids plus the in-flight run state (which work_ids have a live
child not yet work_done). `decide` returns structured dispatch DECISIONS the
loop consumes: {work_id, action} with action SPAWN or SKIP.

For each SPAWN decision the agent MATERIALIZES a per-child config carrying the
CONCRETE work id in a [run.environment.env] WORK_ID overlay -- the channel that
REACHES the child's native script= node env (`-I WORK_ID` does NOT) -- and spawns
the child DETACHED (`fabro run child-W.toml --detach`). The child applies the
UNCHANGED ADR-051 workflow.fabro def, preserving the lead-b3f0 delivery guarantee.
"""
from __future__ import annotations

import json
import os
import subprocess
import sys

ACP_PROTOCOL_VERSION = 1


def decide(pending_ids, in_flight):
    """Return structured dispatch DECISIONS for the poll context.

    ``pending_ids`` -- the pending inbox work ids yielded by the poll node.
    ``in_flight``   -- the set of work_ids whose prior child is still running and
                       has not yet emitted work_done.

    Each decision is a {"work_id", "action"} record.  IDEMPOTENCY: a work id
    whose child is still IN FLIGHT decides "SKIP" (no second child is spawned
    while its prior child is live, so the two cannot collide on the shared
    per-WORK_ID git worktree); a work id with NO live child decides "SPAWN".
    """
    in_flight = set(in_flight or ())
    decisions = []
    for wid in pending_ids:
        action = "SKIP" if wid in in_flight else "SPAWN"
        decisions.append({"work_id": wid, "action": action})
    return decisions


class DispatchTracker:
    """Tracks in-flight work_ids ACROSS poll cycles so each unstarted work id is
    dispatched EXACTLY ONCE.

    Each ``cycle`` merges the tracker's own spawned set with the poll-provided
    in-flight run state, runs ``decide``, and records every SPAWN as now
    in-flight -- so a work id that stays pending across cycles (a slow child,
    Implementer->Reviewer, minutes) is SKIPped on every cycle after the first
    rather than re-spawned into a colliding duplicate child.  This is the
    idempotency the pre-fix context-blind native command dispatch lacked.
    """

    def __init__(self):
        self.in_flight = set()

    def cycle(self, pending_ids, observed_in_flight=None):
        known = set(self.in_flight)
        if observed_in_flight:
            known |= set(observed_in_flight)
        decisions = decide(pending_ids, known)
        for d in decisions:
            if d["action"] == "SPAWN":
                self.in_flight.add(d["work_id"])
        return decisions

    def retire(self, work_id):
        """Drop ``work_id`` from the in-flight set once its child emits
        work_done, so a genuinely new message reusing the id can dispatch again."""
        self.in_flight.discard(work_id)


# --------------------------------------------------------------------------
# Per-child delivery: materialize the WORK_ID env overlay + detached spawn.
# --------------------------------------------------------------------------

def child_config_path(work_id):
    """The per-child .toml entrypoint path for a SPAWN decision (per-WORK_ID, so
    children are isolated)."""
    return "child-%s.toml" % work_id


def materialize_child_config(work_id, bc_name=None):
    """Build the per-child fabro run config for a SPAWN decision.

    It carries the CONCRETE ``work_id`` in a ``[run.environment.env]`` WORK_ID
    overlay -- the PROVEN channel that REACHES the child's native ``script=`` node
    env (unlike ``-I WORK_ID``, which does not) -- and applies the UNCHANGED
    ADR-051 ``workflow.fabro`` child def.  ``bc_name`` defaults to the dispatcher's
    own ``$BC_NAME`` (delivered to this agent's process env by fabro).
    """
    if bc_name is None:
        bc_name = os.environ.get("BC_NAME", "")
    return (
        '[workflow]\n'
        'graph = "workflow.fabro"\n'
        '[run.inputs]\n'
        'BC_NAME = "%s"\n'
        'WORK_ID = "%s"\n'
        '[run.environment.env]\n'
        'BC_NAME = "%s"\n'
        'WORK_ID = "%s"\n'
        '[run.environment]\n'
        'id = "local"\n'
        '[environments.local]\n'
        'provider = "local"\n'
        '[run.pull_request]\n'
        'enabled = false\n'
    ) % (bc_name, work_id, bc_name, work_id)


def spawn_command(work_id):
    """The DETACHED spawn command for a SPAWN decision: ``fabro run
    child-<work_id>.toml --detach``.  The per-child ``.toml`` entrypoint lets
    children run in PARALLEL isolated per WORK_ID; ``--detach`` means the dispatch
    step does not block on them before the loop's wait -> poll back-edge."""
    return ["fabro", "run", child_config_path(work_id), "--detach"]


def spawn_child(work_id, bc_name=None):
    """Materialize the per-child config on disk and spawn the child DETACHED.

    Returns the spawned process handle.  This is the delivery side-effect of a
    SPAWN decision; ``decide`` / ``DispatchTracker`` guarantee it runs exactly
    once per unstarted work id.
    """
    path = child_config_path(work_id)
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(materialize_child_config(work_id, bc_name))
    return subprocess.Popen(spawn_command(work_id))


# --------------------------------------------------------------------------
# ACP JSON-RPC stdio handshake (initialize -> session/new -> session/prompt).
# Non-LLM: no model, no credentials. The handlers are pure and unit-testable.
# --------------------------------------------------------------------------

def handle_initialize(_params):
    return {
        "protocolVersion": ACP_PROTOCOL_VERSION,
        "agentCapabilities": {},
        "serverInfo": {"name": "dispatch_acp_agent", "version": "2"},
    }


def handle_session_new(_params):
    return {"sessionId": "dispatch"}


def _parse_context(params):
    """Pull the poll context (pending ids + in-flight state) out of a
    session/prompt request.  The context rides the prompt as a JSON object with
    keys ``pending`` and ``in_flight``."""
    pending, in_flight = [], set()
    for block in (params or {}).get("prompt", []) or []:
        text = block.get("text") if isinstance(block, dict) else None
        if not text:
            continue
        try:
            payload = json.loads(text)
        except (ValueError, TypeError):
            continue
        pending = list(payload.get("pending", []) or [])
        in_flight = set(payload.get("in_flight", []) or [])
    return pending, in_flight


def handle_session_prompt(params, tracker=None, spawn=spawn_child):
    """Decide over the poll context and EXECUTE each SPAWN by materializing the
    per-child WORK_ID overlay and spawning the child detached.  ``tracker`` (a
    session-scoped DispatchTracker) carries the in-flight set across cycles so
    each unstarted work id is spawned exactly once."""
    pending, in_flight = _parse_context(params)
    if tracker is None:
        decisions = decide(pending, in_flight)
    else:
        decisions = tracker.cycle(pending, observed_in_flight=in_flight)
    spawned = []
    for d in decisions:
        if d["action"] == "SPAWN":
            spawn(d["work_id"])
            spawned.append(d["work_id"])
    return {"stopReason": "end_turn", "decisions": decisions, "spawned": spawned}


def _dispatch_rpc(request, tracker=None):
    method = request.get("method")
    resp = {"jsonrpc": "2.0", "id": request.get("id")}
    if method == "initialize":
        resp["result"] = handle_initialize(request.get("params") or {})
    elif method == "session/new":
        resp["result"] = handle_session_new(request.get("params") or {})
    elif method == "session/prompt":
        resp["result"] = handle_session_prompt(request.get("params") or {}, tracker)
    else:
        resp["error"] = {"code": -32601, "message": "method not found: %s" % method}
    return resp


def main(stdin=None, stdout=None):
    stdin = stdin or sys.stdin
    stdout = stdout or sys.stdout
    # ONE tracker for the life of this ACP agent process, so the in-flight set
    # persists across every session/prompt (poll cycle) fabro drives.
    tracker = DispatchTracker()
    for line in stdin:
        line = line.strip()
        if not line:
            continue
        try:
            request = json.loads(line)
        except ValueError:
            continue
        if "id" not in request:
            continue  # a notification -- no response
        resp = _dispatch_rpc(request, tracker)
        stdout.write(json.dumps(resp) + "\n")
        stdout.flush()


if __name__ == "__main__":
    main()

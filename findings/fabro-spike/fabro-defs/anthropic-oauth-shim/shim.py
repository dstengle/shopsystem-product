#!/usr/bin/env python3
"""
anthropic-oauth-shim — Fabro spike U5 credential-shape shim.

WHY THIS EXISTS
---------------
Fabro's Anthropic adapter authenticates with `x-api-key: <ANTHROPIC_API_KEY>`
against a hardcoded https://api.anthropic.com/v1. The fleet agent-vault MITM
proxy injects the real Anthropic credential ONLY for OAuth-Bearer-shaped
requests (`Authorization: Bearer <dummy>` + `anthropic-beta: oauth-2025-04-20`);
it leaves `x-api-key` untouched. So Fabro's own LLM call is rejected (401
invalid x-api-key).

WHAT THIS DOES
--------------
A tiny local reverse proxy that Fabro's `anthropic` adapter points at via a
`base_url` override. On each request it:
  1. STRIPS the incoming `x-api-key` (and any incoming `authorization`) header
     — the dummy placeholder Fabro holds never leaves this process.
  2. ADDS `Authorization: Bearer <dummy>` and `anthropic-beta: oauth-2025-04-20`
     (merging with any existing anthropic-beta values), keeping
     `anthropic-version` and `content-type`.
  3. FORWARDS to https://api.anthropic.com through the environment HTTPS_PROXY,
     so agent-vault injects the REAL OAuth credential on the wire.
  4. STREAMS the response (SSE or plain JSON) straight back to Fabro.

The adapter stays `anthropic`, so the shim speaks NATIVE Anthropic Messages
format in BOTH directions — NO OpenAI<->Anthropic translation is needed.

INVARIANT #2 (credentials via agent-vault, NOT fabro secrets) IS PRESERVED:
this process never sees or stores a real secret. The real credential is injected
by agent-vault on the wire; Fabro's vault + ANTHROPIC_API_KEY stay dummy
placeholders. Python's urllib picks up HTTPS_PROXY and SSL_CERT_FILE
(the agent-vault MITM CA) from the environment automatically.

USAGE
-----
    ./shim.py [--port 8788] [--host 127.0.0.1] [--upstream https://api.anthropic.com]

Must run in an environment where HTTPS_PROXY and SSL_CERT_FILE point at
agent-vault (as any agent shell here does).
"""
import argparse
import os
import sys
import urllib.request
import urllib.error
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

UPSTREAM = "https://api.anthropic.com"
DUMMY_BEARER = os.environ.get("SHIM_DUMMY_BEARER", "sk-ant-oauth-dummy-proxy-injects-real")

# Headers we must NOT forward upstream (we set our own auth / host / length).
_DROP_REQ = {
    "x-api-key",          # the dummy placeholder — stripped, never forwarded
    "authorization",      # replaced with the OAuth Bearer below
    "host",
    "content-length",     # recomputed by urllib from the body
    "accept-encoding",    # force identity so streaming stays uncompressed
    "connection",
    "proxy-connection",
    "keep-alive",
    "transfer-encoding",
}
# Hop-by-hop response headers we must not copy back verbatim.
_DROP_RESP = {
    "connection", "keep-alive", "proxy-connection", "transfer-encoding",
    "content-length", "content-encoding",
}


class Handler(BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"
    server_version = "anthropic-oauth-shim/1.0"

    def log_message(self, fmt, *args):  # quieter, to stderr
        sys.stderr.write("[shim] %s - %s\n" % (self.address_string(), fmt % args))

    def _proxy(self):
        length = int(self.headers.get("content-length") or 0)
        body = self.rfile.read(length) if length else None

        # Build the outbound header set: keep everything except the drop list,
        # then force the OAuth shape.
        out_headers = {}
        beta_values = []
        for k, v in self.headers.items():
            lk = k.lower()
            if lk == "anthropic-beta":
                beta_values.append(v)
                continue
            if lk in _DROP_REQ:
                continue
            out_headers[k] = v
        out_headers["Authorization"] = "Bearer " + DUMMY_BEARER
        beta_values.append("oauth-2025-04-20")
        # de-dup while preserving order
        seen = set()
        merged_beta = []
        for chunk in beta_values:
            for tok in chunk.split(","):
                tok = tok.strip()
                if tok and tok not in seen:
                    seen.add(tok)
                    merged_beta.append(tok)
        out_headers["anthropic-beta"] = ", ".join(merged_beta)

        url = UPSTREAM.rstrip("/") + self.path
        req = urllib.request.Request(url, data=body, method=self.command)
        for k, v in out_headers.items():
            req.add_header(k, v)

        # urllib.request honours HTTPS_PROXY + SSL_CERT_FILE from the env.
        try:
            resp = urllib.request.urlopen(req, timeout=600)
            status = resp.status
            resp_headers = resp.headers
            stream = resp
        except urllib.error.HTTPError as e:
            status = e.code
            resp_headers = e.headers
            stream = e  # HTTPError is a readable file-like of the error body
        except Exception as e:
            self.send_error(502, "shim upstream error: %s" % e)
            return

        # Relay status + headers, then stream the body. We use Connection: close
        # and no Content-Length so the client reads the (possibly SSE) body to EOF.
        self.send_response(status)
        for k, v in resp_headers.items():
            if k.lower() in _DROP_RESP:
                continue
            self.send_header(k, v)
        self.send_header("Connection", "close")
        self.end_headers()
        try:
            while True:
                chunk = stream.read(8192)
                if not chunk:
                    break
                self.wfile.write(chunk)
                self.wfile.flush()
        except (BrokenPipeError, ConnectionResetError):
            pass
        finally:
            try:
                stream.close()
            except Exception:
                pass
        self.close_connection = True

    do_POST = _proxy
    do_GET = _proxy
    do_PUT = _proxy
    do_DELETE = _proxy


def main():
    global UPSTREAM
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", default="127.0.0.1")
    ap.add_argument("--port", type=int, default=8788)
    ap.add_argument("--upstream", default=UPSTREAM)
    args = ap.parse_args()
    UPSTREAM = args.upstream
    srv = ThreadingHTTPServer((args.host, args.port), Handler)
    proxy = os.environ.get("HTTPS_PROXY", "<unset>")
    # redact proxy creds in the log line
    if "@" in proxy:
        proxy = "http://<redacted>@" + proxy.split("@", 1)[1]
    sys.stderr.write(
        "[shim] listening on http://%s:%d  ->  %s  via HTTPS_PROXY=%s\n"
        % (args.host, args.port, UPSTREAM, proxy)
    )
    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        srv.shutdown()


if __name__ == "__main__":
    main()

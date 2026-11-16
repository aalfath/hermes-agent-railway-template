# Hermes Agent on Railway

Railway template for [Hermes Agent](https://github.com/NousResearch/hermes-agent), the open-source, self-improving AI agent by Nous Research (MIT).

## What it deploys

One service, built from this repo:

- **Image:** `nousresearch/hermes-agent:v0.23.1`, pinned by digest in the [`Dockerfile`](Dockerfile).
- **Processes:** the image's own s6-overlay supervisor runs the Hermes **gateway** (messaging platforms and the cron scheduler) and the **web dashboard**. It restarts either one if it crashes.
- **Public URL:** the web dashboard, on Railway's `PORT` (9119). It covers chat, model and provider setup, API keys, sessions, skills, MCP servers, cron jobs, channels and logs.
- **Volume:** `/opt/data` holds everything: `config.yaml`, `.env` (API keys you add in the dashboard), sessions, memory, skills and logs.
- **Health check:** `GET /api/status` (public, no login).

[`railway-start.sh`](railway-start.sh) sets the defaults below and then hands over to the image's own entrypoint. Nothing else is changed.

## Variables

| Variable | Default | What it does |
|---|---|---|
| `HERMES_DASHBOARD_BASIC_AUTH_USERNAME` | `admin` | Dashboard login name |
| `HERMES_DASHBOARD_BASIC_AUTH_PASSWORD` | `${{secret(32)}}` | Dashboard password, generated at deploy. Read it in the service's Variables tab |
| `HERMES_DASHBOARD_BASIC_AUTH_SECRET` | `${{secret(48)}}` | Signs login sessions, so you stay logged in across redeploys |
| `PORT` | `9119` | Port the dashboard listens on |

There's no default password, and the dashboard won't start without a login. After the first login, add an LLM provider key (OpenRouter, Anthropic, OpenAI, Nous Portal and others) on the dashboard's **API Keys** page, or connect chat platforms on **Channels**.

Optional, set them yourself on the service:

- `HERMES_DASHBOARD_OAUTH_CLIENT_ID`: sign in with Nous Portal instead of a password. Upstream recommends this, or `HERMES_DASHBOARD_OIDC_ISSUER` plus `HERMES_DASHBOARD_OIDC_CLIENT_ID` for your own OIDC provider, for dashboards on the public internet. See the [web dashboard docs](https://github.com/NousResearch/hermes-agent/blob/main/website/docs/user-guide/features/web-dashboard.md#authentication-gated-mode). The public URL is set from the Railway domain automatically.
- `API_SERVER_ENABLED=true`, `API_SERVER_HOST=0.0.0.0` and `API_SERVER_KEY`: expose the OpenAI-compatible API on port 8642 over Railway's private network. See the [API server docs](https://github.com/NousResearch/hermes-agent/blob/main/website/docs/user-guide/features/api-server.md).

## Updates

Each new Hermes release is a pull request here that bumps the pinned version and digest and adds a [`CHANGELOG.md`](CHANGELOG.md) entry. When it's merged to `main`, Railway shows everyone who deployed the template an "update available" notice, and you choose when to apply it. Your `/opt/data` volume is kept.

## Local run

```sh
docker build -t hermes-railway .
docker run -p 9119:9119 -e PORT=9119 \
  -e HERMES_DASHBOARD_BASIC_AUTH_PASSWORD="$(openssl rand -hex 16)" \
  -e HERMES_DASHBOARD_BASIC_AUTH_SECRET="$(openssl rand -hex 32)" \
  -v hermes-data:/opt/data hermes-railway
```

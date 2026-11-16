# Changelog

## Unreleased (2026-11-16)

- README: Deploy on Railway button for the published template `hermes-agent-12`. No change to the image or the service.

## v0.23.1 (2026-11-16)

- First release of the template: Hermes Agent v0.23.1 (`nousresearch/hermes-agent:v0.23.1@sha256:276d44685c65c0cb2a25f190b63c65c8906f9dc76486fb1c05ae71b5826bda08`).
- One service: the gateway and the web dashboard under the image's s6 supervisor, with `/opt/data` on a volume and a health check on `/api/status`.
- Dashboard login: username `admin` and a password generated at deploy.
- Railway's edge proxy (`100.64.0.0/10`) goes in `dashboard.trusted_proxies` when that setting is empty, so login cookies are `Secure` and the login rate limit counts each visitor.

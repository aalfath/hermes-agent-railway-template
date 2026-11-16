# Changelog

## v0.23.1 (2026-11-16)

- First release of the template: Hermes Agent v0.23.1 (`nousresearch/hermes-agent:v0.23.1@sha256:276d44685c65c0cb2a25f190b63c65c8906f9dc76486fb1c05ae71b5826bda08`).
- One service: the gateway and the web dashboard under the image's s6 supervisor, with `/opt/data` on a volume and a health check on `/api/status`.
- Dashboard login: username `admin` and a password generated at deploy.

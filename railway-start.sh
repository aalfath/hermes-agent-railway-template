#!/bin/sh
# Railway wrapper for the official Hermes Agent image.
# Sets defaults, then hands over to the image's own entrypoint (s6-overlay /init as PID 1),
# which supervises the gateway and the web dashboard. Data lives in /opt/data (the volume).
set -e

export HERMES_DASHBOARD="${HERMES_DASHBOARD:-1}"
export HERMES_DASHBOARD_HOST="${HERMES_DASHBOARD_HOST:-0.0.0.0}"
export HERMES_DASHBOARD_PORT="${HERMES_DASHBOARD_PORT:-${PORT:-9119}}"
export HERMES_DASHBOARD_BASIC_AUTH_USERNAME="${HERMES_DASHBOARD_BASIC_AUTH_USERNAME:-admin}"

# OAuth callbacks need the public https address; Railway gives it to us.
if [ -z "${HERMES_DASHBOARD_PUBLIC_URL:-}" ] && [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
    export HERMES_DASHBOARD_PUBLIC_URL="https://${RAILWAY_PUBLIC_DOMAIN}"
fi

# The dashboard refuses to serve a public address without a login. Say why up front.
if [ -z "${HERMES_DASHBOARD_BASIC_AUTH_PASSWORD:-}${HERMES_DASHBOARD_BASIC_AUTH_PASSWORD_HASH:-}${HERMES_DASHBOARD_OAUTH_CLIENT_ID:-}${HERMES_DASHBOARD_OIDC_ISSUER:-}" ]; then
    echo "[railway] No dashboard login configured: set HERMES_DASHBOARD_BASIC_AUTH_PASSWORD" >&2
    echo "[railway] (or HERMES_DASHBOARD_OAUTH_CLIENT_ID / HERMES_DASHBOARD_OIDC_ISSUER). The dashboard will not start." >&2
fi

exec /opt/hermes/docker/entrypoint-dispatch.sh "$@"

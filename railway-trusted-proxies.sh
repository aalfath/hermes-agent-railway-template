#!/command/with-contenv sh
# shellcheck shell=sh
# s6 cont-init hook (runs as root after the image's own 01-hermes-setup, before services start).
#
# Railway's edge proxy reaches the container from 100.64.0.0/10. Trusting that range for
# X-Forwarded-Proto/For lets the dashboard mark its login cookies Secure and rate-limit
# password logins per visitor instead of per proxy. It only fills in
# dashboard.trusted_proxies when it is empty, so a value you set yourself is kept.
# Opt out with RAILWAY_TRUSTED_PROXY_CIDR="" (empty).
set -u

[ -n "${RAILWAY_ENVIRONMENT_ID:-}" ] || exit 0
cidr="${RAILWAY_TRUSTED_PROXY_CIDR-100.64.0.0/10}"
[ -n "$cidr" ] || exit 0

cd /opt/data || exit 0
export HOME=/opt/data
current="$(s6-setuidgid hermes hermes config get dashboard.trusted_proxies 2>/dev/null || true)"
if [ -z "$current" ] || [ "$current" = "[]" ]; then
    if s6-setuidgid hermes hermes config set dashboard.trusted_proxies "[$cidr]" >/dev/null 2>&1; then
        echo "[railway] dashboard.trusted_proxies set to $cidr (Railway edge proxy)"
    else
        echo "[railway] could not set dashboard.trusted_proxies; continuing without it" >&2
    fi
fi
exit 0

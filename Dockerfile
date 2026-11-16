# Hermes Agent (Nous Research) for Railway.
# Upstream image, pinned by version and digest. Bump both together and add a CHANGELOG entry.
FROM nousresearch/hermes-agent:v0.23.1@sha256:276d44685c65c0cb2a25f190b63c65c8906f9dc76486fb1c05ae71b5826bda08

COPY --chmod=0755 railway-start.sh /usr/local/bin/railway-start.sh

# Runs before the image's own s6-overlay entrypoint and only sets defaults:
# dashboard on, bound to Railway's PORT, username "admin", public URL from the Railway domain.
ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
CMD ["gateway", "run"]

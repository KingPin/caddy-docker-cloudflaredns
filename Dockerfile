# syntax=docker/dockerfile:1
FROM caddy:builder-alpine AS builder

RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    xcaddy build \
      --with github.com/caddy-dns/cloudflare \
      --with github.com/lucaslorentz/caddy-docker-proxy/v2

FROM caddy:alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Probes Caddy's admin API (default 127.0.0.1:2019). Override or disable
# (`--no-healthcheck`) if you set `admin off` in your Caddyfile.
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://127.0.0.1:2019/config/ || exit 1

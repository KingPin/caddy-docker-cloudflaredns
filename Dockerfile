FROM caddy:builder-alpine AS builder

RUN xcaddy build \
--with github.com/mholt/caddy-l4 \
--with github.com/caddy-dns/cloudflare

FROM caddy:latest

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

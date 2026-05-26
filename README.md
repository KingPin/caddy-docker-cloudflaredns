
# caddy-docker-cloudflaredns
Caddy webserver v2 in a docker with the following plugins built in:

- [`caddy-dns/cloudflare`](https://github.com/caddy-dns/cloudflare) — Cloudflare DNS provider for ACME DNS-01 challenges.
- [`lucaslorentz/caddy-docker-proxy`](https://github.com/lucaslorentz/caddy-docker-proxy) — generates the Caddyfile from labels on other Docker containers, so Caddy auto-configures itself as you start/stop services.

The docker containers are built for amd64, arm64 / aarch64, and arm/v7.
Available at:

- `kingpin/caddy-docker-cloudflaredns:latest` (Docker Hub)
- `ghcr.io/kingpin/caddy-docker-cloudflaredns:latest` (GHCR)
- `quay.io/kingpinx1/caddy-docker-cloudflaredns:latest` (Quay)

The image ships a `HEALTHCHECK` that probes Caddy's admin API on `127.0.0.1:2019`. If you set `admin off` in your Caddyfile, run with `--no-healthcheck` or override `HEALTHCHECK` in your own image.

**docker run** : 

    docker run -it --name caddy \
         -p 80:80 \
         -p 443:443 \
         -v ./caddy_data:/data \
         -v ./caddy_config:/config \
         -v ./Caddyfile:/etc/caddy/Caddyfile \
         -e CLOUDFLARE_EMAIL=you@cloudflare.email.com \
         -e CLOUDFLARE_API_TOKEN=iHFh938nf93r39jsSnS4Q5zw04q0EsRG7xmalB \
         kingpin/caddy-docker-cloudflaredns

**Docker-compose.yml**

    version: "3.7"
    services:
      caddy:
        image: ghcr.io/kingpin/caddy-docker-cloudflaredns:latest
        container_name: caddy
        environment:
          - CLOUDFLARE_EMAIL=your@cloudflare.email
          - CLOUDFLARE_API_TOKEN=iHFh938nf93r39jsSnS4Q5zw04q0EsRG7xmalB
        ports:
          - 80:80
          - 443:443
        volumes:
                - './caddy/Caddyfile:/etc/caddy/Caddyfile'
                - './caddy/caddy_data:/data'
                - './caddy/caddy_config:/config'
        restart: unless-stopped


this is a bare basic example, you may need to modify it further to suit your setup. 

Get Cloudflare api token following this token : https://support.cloudflare.com/hc/en-us/articles/200167836-Managing-API-Tokens-and-Keys

edit your Caddyfile with this at the top : 

    { 
        acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN} 
    }

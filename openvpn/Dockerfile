FROM ubuntu:20.04
MAINTAINER a@ioot.xyz

RUN >/dev/null apt-get update -y && \
    >/dev/null DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    >/dev/null DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    openvpn \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

VOLUME ["/vpn"]
ENTRYPOINT ["openvpn"]
CMD [ "--config", "/vpn/vpn.conf" ]

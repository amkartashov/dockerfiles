FROM debian:9

VOLUME /data
WORKDIR /data/dst/bin

ENTRYPOINT ["/bin/entrypoint"]

RUN dpkg --add-architecture i386 && apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386

ADD entrypoint.sh /bin/entrypoint
RUN chmod +x /bin/entrypoint


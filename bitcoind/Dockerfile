ARG DEBIANTAG

FROM debian:${DEBIANTAG}

LABEL maintainer.0="primeroz"

ARG BITCOIND_VERSION
ARG ENTRYPOINT_VERSION
ARG TARGETPLATFORM
ARG TARGETARCH
ENV BITCOIN_DATA=/home/bitcoin/.bitcoin
ENV PATH=/opt/bitcoin-${BITCOIND_VERSION}/bin:$PATH

RUN set -ex \
  && addgroup --gid 1000 bitcoin \
  && adduser --disabled-login --system --shell /bin/false --uid 1000 --gid 1000 bitcoin \
  && apt-get update -y \
  && apt-get install -y --no-install-recommends --no-install-suggests curl gnupg jq gosu ca-certificates \
  && c_rehash \
  && for key in \
    01EA5486DE18A882D4C2684590C8019E36C2E964 \
  ; do \
      gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" || \
      gpg --batch --keyserver pgp.mit.edu --recv-keys "$key" || \
      gpg --batch --keyserver keyserver.pgp.com --recv-keys "$key" || \
      gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
      gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ; \
    done \
  && if [ "x$TARGETARCH" = "xarm" ]; then export BIN_ARG_SUFFIX=arm-linux-gnueabihf; fi \
  && if [ "x$TARGETARCH" = "xarm64" ]; then export BIN_ARG_SUFFIX=aarch64-linux-gnu; fi \
  && if [ "x$TARGETARCH" = "xamd64" ]; then export BIN_ARG_SUFFIX=x86_64-linux-gnu; fi \
  && curl -SLO https://bitcoin.org/bin/bitcoin-core-${BITCOIND_VERSION}/SHA256SUMS.asc \
  && curl -SLO https://bitcoin.org/bin/bitcoin-core-${BITCOIND_VERSION}/bitcoin-${BITCOIND_VERSION}-${BIN_ARG_SUFFIX}.tar.gz \
  && gpg --verify SHA256SUMS.asc \
  && grep " bitcoin-${BITCOIND_VERSION}-${BIN_ARG_SUFFIX}.tar.gz\$" SHA256SUMS.asc | sha256sum -c - \
  && tar -xzf *.tar.gz -C /opt \
  && rm *.tar.gz *.asc \
  && apt-get purge --auto-remove -y \
        dirmngr \
        gnupg \
        curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN set -ex \
  && apt-get update -y \
  && apt-get install -y --no-install-recommends --no-install-suggests curl ca-certificates \
  && if [ "x$TARGETARCH" = "xarm" ]; then export ENTRYPOINT_ARCH=armv7l; fi \
  && if [ "x$TARGETARCH" = "xarm64" ]; then export ENTRYPOINT_ARCH=arm64; fi \
  && if [ "x$TARGETARCH" = "xamd64" ]; then export ENTRYPOINT_ARCH=x86_64; fi \
  && curl -SLo /entrypoint https://github.com/bigfreeze-code/parameterized-entrypoint/releases/download/${ENTRYPOINT_VERSION}/entrypoint_${ENTRYPOINT_ARCH} \
  && chmod a+x /entrypoint \
  && apt-get purge --auto-remove -y \
        curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY /docker-entrypoint.d/* /docker-entrypoint.d/
RUN chmod a+x /docker-entrypoint.d/*

EXPOSE 8332 8333 18332 18333 18443 18444

ENTRYPOINT ["/entrypoint"]

CMD ["--scripts", "/docker-entrypoint.d", "--", "echo", "gosu", "bitcoind:bitcoind", "-disablewallet", "-pid=/run/bitcoind/bitcoind.pid", "-conf=${BITCOIN_DATA}/bitcoin.conf", "-datadir=${BITCOIN_DATA}]

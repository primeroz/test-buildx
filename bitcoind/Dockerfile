ARG DEBIANTAG


FROM debian:${DEBIANTAG} as entrypoint

RUN set -ex \    
  && apt-get update -y \
  && apt-get install -y --no-install-recommends --no-install-suggests git python3 python3-pip python3-setuptools python3-wheel python3-dev binutils build-essential libz-dev \
  && git clone https://github.com/bigfreeze-code/parameterized-entrypoint.git \
  && cd parameterized-entrypoint \
  && pip3 install -r requirements.txt \
  && python3 setup.py build \
  && chmod 755 dist/entrypoint \
  && mv dist/entrypoint /tmp

FROM debian:${DEBIANTAG}

LABEL maintainer.0="bigfreeze"

ARG BITCOIND_VERSION
ARG BIN_ARG_SUFFIX
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

COPY --from=entrypoint /tmp/entrypoint /usr/local/bin/entrypoint

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

COPY /docker-entrypoint.d/* /docker-entrypoint.d/
RUN chmod a+x /docker-entrypoint.d/*

VOLUME ["/home/bitcoin/.bitcoin"]

EXPOSE 8332 8333 18332 18333 18443 18444

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bitcoind"]

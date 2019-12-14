ARG DEBIANTAG
FROM debian:${DEBIANTAG}
MAINTAINER "bigfreeze"

ENV GPGKEY=A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE="True"
ENV DEBIAN_FRONTEND=noninteractive

# Set a default Nickname
ENV TOR_NICKNAME=Tor4
ENV TOR_USER=tord
ENV TERM=xterm

# Install prerequisites
RUN apt-get update \
 && apt-get install --no-install-recommends --no-install-suggests -y \
        apt-transport-https \
        bash \
        ca-certificates \
        dirmngr \
        apt-utils \
        gnupg \
        curl \
 # Add torproject.org Debian repository for stable Tor version \
 && curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import \
 && gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add - \
 && echo "deb https://deb.torproject.org/torproject.org buster main"   >  /etc/apt/sources.list.d/tor-apt-sources.list \
 && echo "deb-src https://deb.torproject.org/torproject.org buster main" >> /etc/apt/sources.list.d/tor-apt-sources.list \
 && apt-get update \
 && apt-get install --no-install-recommends --no-install-suggests -y \
        tor \
        tor-geoipdb \
        deb.torproject.org-keyring \
 && mkdir -pv /usr/local/etc/tor/ \
 && mv -v /etc/tor/torrc /usr/local/etc/tor/torrc.sample \
 && apt-get purge --auto-remove -y \
        apt-transport-https \
        dirmngr \
        apt-utils \
        gnupg \
        curl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 # Rename Debian unprivileged user to tord \
 && usermod -l tord -u 1000 debian-tor \
 && groupmod -n tord -g 1000 debian-tor

ENV ETCDIR=/tmp/tor
ENV DATADIR=/var/lib/tor
ENV CONTROLDIR=/run/tor

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

COPY /docker-entrypoint.d/* /docker-entrypoint.d/
RUN chmod a+x /docker-entrypoint.d/*

# Persist data
# VOLUME /etc/tor /var/lib/tor /run/tor
VOLUME $DATADIR

# ORPort, DirPort, SocksPort, ObfsproxyPort, MeekPort
#EXPOSE 9001 9030 9050 54444 7002
EXPOSE 9050 9051

ENTRYPOINT ["/entrypoint.sh"]
CMD ["tor", "-f", "${ETCDIR}/torrc"]

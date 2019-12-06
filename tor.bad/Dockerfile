ARG DEBIANTAG

FROM debian:${DEBIANTAG}

LABEL maintainer.0="bigfreeze"

ARG tor_version

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
        ca-certificates \
        dirmngr \
        apt-utils \
        gnupg \
        curl \
 && c_rehash \
 # Add torproject.org Debian repository for stable Tor version \
 && curl https://deb.torproject.org/torproject.org/$GPGKEY.asc | gpg --import \
 && gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add - \
 && echo "deb https://deb.torproject.org/torproject.org buster main"   >  /etc/apt/sources.list.d/tor-apt-sources.list \
 && echo "deb-src https://deb.torproject.org/torproject.org buster main" >> /etc/apt/sources.list.d/tor-apt-sources.list \
 # Install tor with GeoIP and obfs4proxy & backup torrc \
 && apt-get update \
 && apt-get install --no-install-recommends --no-install-suggests -y \
        pwgen \
        iputils-ping \
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
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 # Rename Debian unprivileged user to tord \
 && usermod -l tord debian-tor \
 && groupmod -n tord debian-tor

RUN     mkdir -p /etc/tor/

#COPY    assets/onions /usr/local/src/onions
#COPY    assets/torrc /var/local/tor/torrc.tpl


#RUN     mkdir -p ${HOME}/.tor && \
#    addgroup -S -g 107 tor && \
#    adduser -S -G tor -u 104 -H -h ${HOME} tor

#COPY    assets/entrypoint-config.yml /

VOLUME  ["/var/lib/tor/hidden_service/"]

# placeholder
ENTRYPOINT ["sh"]

CMD     ["tor"]

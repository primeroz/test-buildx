ARG DEBIANTAG

FROM debian:${DEBIANTAG}

LABEL maintainer.0="bigfreeze"

COPY /docker-entrypoint.sh /
RUN chmod a+x /entrypoint.sh

COPY /docker-entrypoint.d/* /docker-entrypoint.d/

ONBUILD COPY /docker-entrypoint.d/* /docker-entrypoint.d/

ENTRYPOINT ["/docker-entrypoint.sh"]

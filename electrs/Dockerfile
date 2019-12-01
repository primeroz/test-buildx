FROM rust:1.34.0-slim as BUILD
#FROM --platform=$TARGETPLATFORM rust:1.34.0-slim

ARG     electrs_version

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y clang cmake libsnappy-dev git \
    && mkdir -p /usr/local/src/ \
    && git clone https://github.com/romanz/electrs.git /usr/local/src/electrs \
    && cd /usr/local/src/electrs \
    && git checkout v$electrs_version \
    && cargo build --release && cargo install --path . \
    && apt-get remove -y clang cmake libsnappy-dev git \
    && apt-get clean all \
    && rm -rf /usr/local/src/electrs

FROM debian:stretch-slim

COPY --from=BUILD /usr/local/cargo/bin/electrs /usr/local/bin/electrs

RUN adduser --disabled-login --system --shell /bin/false --uid 1000 user
USER user

# Electrum RPC
EXPOSE 50001

# Prometheus monitoring
EXPOSE 4224

STOPSIGNAL SIGINT

# placeholder
ENTRYPOINT ["sh"]

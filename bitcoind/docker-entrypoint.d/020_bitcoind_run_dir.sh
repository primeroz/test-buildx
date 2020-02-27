#!/usr/bin/env bash
set -e

mkdir -p /run/bitcoind
chmod 750 /run/bitcoind
chown -R bitcoin:bitcoin /run/bitcoind

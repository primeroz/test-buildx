#!/usr/bin/env bash
set -e

if [[ -d "$BITCOIN_DATA" ]]; then
  chmod 750 $BITCOIN_DATA
  chown -R bitcoin:bitcoin $BITCOIN_DATA
fi

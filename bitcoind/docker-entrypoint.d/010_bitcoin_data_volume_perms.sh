#!/usr/bin/env bash
set -e

if [[ -d "$BITCOIN_DATA" ]]; then
  cmod 750 $BITCOIN_DATA
  chown -R bitcoin:bictoin $BITCOIN_DATA
fi

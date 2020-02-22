#!/usr/bin/env bash
set -e

### Only do the onion_services subdir ?
if [[ -d "$DATADIR" ]]; then
  chmod 0750 $DATADIR
  chown -R tord:tord $DATADIR
fi

#!/usr/bin/env bash
set -e

ETCDIR=${ETCDIR:-/tmp/tor}
DATADIR=${DATADIR:-/var/lib/tor}
CONTROLDIR=${CONTROLDIR:-/run/tor}


mkdir -p $ETCDIR
chmod 700 $ETCDIR
chown -R tord:tord $ETCDIR

mkdir -p $DATADIR
chmod 700 $DATADIR
chown -R tord:tord $DATADIR


mkdir -p $CONTROLDIR
chmod 700 $CONTROLDIR
chown -R tord:tord $CONTROLDIR
